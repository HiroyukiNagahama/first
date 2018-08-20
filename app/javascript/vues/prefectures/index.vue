<template>
    <div class="row">
      <div class="col-xs-12 col-md-11">
        <input v-model="newPrefecture.name" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col-xs-2 col-md-1">

        <div class="btn-floating waves-effect waves-light red btn" v-on:click="createPrefectureAsync(newPrefecture)">
          <i class="material-icons">add</i>
        </div>
      </div>

      <table class="table table-dark">
        <thead>
        <tr>
          <td></td>
          <td>名称</td>
          <td>エリア名称</td>
          <td>コード</td>
          <td>フラグ</td>
          <td></td>
        </tr>
        </thead>
        <tbody>

        <tr v-for="prefecture in prefectures" v-bind:id="'row_prefecture_' + prefecture.id">
          <td>
            <input type="checkbox" v-on:change="doneTask(prefecture.id)" v-bind:id="'prefecture_' + prefecture.id"/>
          </td>
          <td v-model="prefecture.name">{{ prefecture.name }}</td>
          <td>
            <ul style="text-aline: center;">
              <li style="display: inline-block">
                <span v-if="!prefecture.edit_flag">{{ transrateAreaName(prefecture) }}</span>
              </li>
              <li style="display: inline-block">
                <select v-if="prefecture.edit_flag" v-model="prefecture.area_cd" class="form-control">
                  <option v-for="area in areas" v-bind:value="area.code">
                    {{ area.name }}
                  </option>
                </select>
              </li>
              <li style="display: inline-block">
                <button class="btn btn-default" v-on:click="editable(prefecture)">編集</button>
                <button class="btn btn-default" v-on:click="updateAreaCode(prefecture)">更新</button>
              </li>
            </ul>
          </td>
          <!--// TODO 要修正-->
          <td v-model="prefecture.code">{{ prefecture.code }}</td>
          <td v-model="prefecture.go_flag">{{ prefecture.go_flag }}</td>
          <td>
            <a v-bind:href="'/prefectures/'+ prefecture.id ">
              <button class="btn btn-primary">
                編集だよ
              </button>
            </a>
          </td>
        </tr>

        </tbody>
      </table>
    </div>
</template>

<script>
  import axios from 'axios';

  axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
  import { mapActions } from 'vuex'

  import Multiselect from 'vue-multiselect'

  export default {
    components: {Multiselect},
    data: function () {
      return {
        prefectures: [],
        newPrefecture: {code: '', current_company_code: '', name: ''},
        // updatePrefecture: {code: '', area_cd: '', name: ''},
        areas: []
      }
    },
    mounted: function () {
      this.fetchUser();
      this.fetchPrefectures();
      this.fetchNewData();
      this.fetchArea();
    },
    computed: {
      // 引数を取ることができない。（componentから辿って無理すれば出来そうな感じ）
    },
    methods: {
      // load時にprefecturesをセットする
      fetchUser: function() {
        axios.get('/prefectures/load_user').then((response) => {
          this.newPrefecture.code = response.data.code;
          this.newPrefecture.current_company_code = response.data.current_company_code;
        }, (error) => {
          console.log(error);
        });
      },
      fetchArea: function(){
        axios.get('/prefectures/load_area').then((response) => {
          this.areas = response.data
          this.$store.commit('setupArea', this.areas)
        }, (error) => {
          console.log(error);
        });
      },
      fetchPrefectures: function () {
        axios.get('/prefectures/load_index').then((response) => {
          if (response.data == null) {
            return
          }
          for (var i = 0; i < response.data.length; i++) {
            // add property for edit
            response.data[i].edit_flag = false
            this.prefectures.push(response.data[i]);
          }
          this.$store.commit('setupPrefectures', this.prefectures)
        }, (error) => {
          console.log(error);
        });
      },
      fetchNewData: function() {
        this.$store.commit('setupNewPrefecture', this.newPrefecture)
        // this.$store.commit('setupUpdatePrefecture', this.UpdatePrefecture)
      },
      ...mapActions(
        [
          'createPrefectureAsync',
          'updateAreaCode'
      ]),
      transrateAreaName: function(prefecture){
        const selectedArea = this.areas.find(element => element.code == prefecture.area_cd)
        if(selectedArea!=null){
          return selectedArea.name
        }
        return '選択なし'
      },
      // TODO 要修正
      editable: function(prefecture){
        if(prefecture.edit_flag){
          this.$store.dispatch('updateAreaCode', { area_cd: prefecture.area_cd, code: prefecture.code })
          prefecture.edit_flag = !prefecture.edit_flag
        } else {
          prefecture.edit_flag = !prefecture.edit_flag
        }
      }

    }
  }

</script>