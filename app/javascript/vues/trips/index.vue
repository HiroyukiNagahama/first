<template>
    <div>
        <table class="table">
            <thead>
            <th>#</th>
            <th>名称</th>
            <th>開始日</th>
            <th>終了日</th>
            <th>メイン都道府県</th>
            <th>都道府県</th>
            </thead>
            <tbody>
            <tr v-for="trip in trips" v-bind:id="'row_tirp_' + trip.id" class="collection-item" scope="trip">
                <!--<td><input type="checkbox" v-on:change="doneTrip(trip.id)" v-bind:id="'trip_' + trip.id" /></td>-->
                <td><input type="checkbox" /></td>
                <td v-bind:for="'task_' + trip.id">
                    <span v-on:click="editName(trip)" v-if="!trip.edit_name">{{trip.name}}</span>
                    <input type="text" v-model="trip.name" v-if="trip.edit_name" v-on:blur="saveName(trip)" v-focus>
                </td>
                <td>{{ trip.start_date }}</td>
                <td>{{ trip.end_date }}</td>
                <td>
                    <span v-on:click="editSelect(trip)" v-if="!trip.edit_select">{{ trip.main_prefecture }}</span>
                    <span>{{ prefectureName(trip) }}</span>
                    <!--<span>{{ selected }}</span>-->
                    <select v-model="trip.main_prefecture" required v-if="trip.edit_select" v-on:blur="saveSelect(trip)" >
                        <option v-for="pref in prefectures" :value="pref.id">{{pref.name}}</option>
                    </select>
                </td>
                <td>
                    <span v-on:click="editMutliSelect(trip)" v-if='!trip.multi_select'>{{ trip.visit_prefectures }}</span>
                    <div class="btn btn-default" v-on:click="editMutliSelect(trip)">hoge</div>
                    <div>
                    <multiselect
                            v-if='trip.multi_select'
                            v-model="trip.visit_prefectures"
                            :options="prefecture_options"
                            :multiple="true"
                            :close-on-select="false"
                            :hide-selected="true"

                            :preserve-search="true"
                            placeholder="選択して下さい。検索可能だ"
                            label="name"
                            track-by="name"
                    >
                        <template slot="tag" slot-scope="props">
                            <span class="custom__tag">
                                <span>{{ props.option.name }}</span>
                                <span class="custom__remove" v-on:click="props.remove(props.option)">❌</span>
                            </span>
                        </template>
                    </multiselect>
                        <div class="btn btn-default" v-on:click="saveMutliSelect(trip)">hoge</div>
</div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
    import axios from 'axios';
    axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
    import Multiselect from 'vue-multiselect'

    export default {
        components: {Multiselect},
        data: function () {
            return {
                trips: [],
                prefectures: [],
                prefecture_options: []
            }
        },
        mounted: function () {
            this.fetchTrips();
            this.fetchPrefectures();
            this.fetchPrefectureLists();
        },
        directives: {
            focus: {
                // ディレクティブ定義
                inserted: function (el) {
                    el.focus()
                }
            }
        },
        // computed: {
        //     prefectureName: function(){
        //         this.prefectures
        //         console.log(this.prefectures)
        //         return 'hoge'
        //     }
        // },
        methods: {
            prefectureName: function(trip){
                var pref_lists = this.prefectures.filter(function(prefecture){
                    return prefecture.id　=== trip.main_prefecture && prefecture.name != null
                })
                return pref_lists[0].name
            },
            fetchTrips: function () {
                axios.get('/trips/load_index').then((response) => {
                    if(response.data == null){return}
                    for (var i = 0; i < response.data.length; i++) {
                        var trip_data = response.data[i]
                        trip_data.edit_name = false
                        trip_data.edit_date = false
                        trip_data.edit_select = false
                        trip_data.multi_select = false
                        this.trips.push(trip_data);
                    }
                }, (error) => {
                    console.log(error);
                });
            },
            fetchPrefectures: function() {
                axios.get('/prefectures/load_index').then((response) => {
                    // console.log(response)
                    if(response.data == null){return}
                    for (var i = 0; i < response.data.length; i++) {
                        this.prefectures.push(response.data[i]);
                    }
                }, (error) => {
                    console.log(error);
                });
            },
            fetchPrefectureLists: function() {
                axios.get('/prefectures/lists').then((response) => {
                    // console.log(response)
                    if(response.data == null){return}
                    for (var i = 0; i < response.data.length; i++) {
                        console.log(response.data[i])
                        this.prefecture_options.push(response.data[i]);
                    }
                }, (error) => {
                    console.log(error);
                });
            },
            editName: function(trip){
                trip.edit_name = true
            },
            saveName : function(trip){
                axios.patch('/trips/update/'+ trip.id, { name: trip.name }).then(
                    (response) => {
                        trip.edit_name = false
                    },
                    (error) => {
                      console.log(error);
                    }
                );
            },
            editSelect: function(trip){
                trip.edit_select = true
            },
            saveSelect: function(trip) {
                axios.patch('/trips/update/'+ trip.id, { main_prefecture: trip.main_prefecture }).then(
                    (response) => {
                        trip.edit_select = false
                    },
                    (error) => {
                        console.log(error);
                    }
                );
            },
            editMutliSelect: function(trip){
                trip.multi_select = true
            },
            saveMutliSelect: function(trip) {
                alert('OK?')
                axios.patch('/trips/update/'+ trip.id, { visit_prefectures: trip.visit_prefectures }).then(
                    (response) => {
                        alert('OK')
                        trip.multi_select = false
                    },
                    (error) => {
                        console.log(error);
                    }
                );
            },

            // moveFinishedTask: function(task_id) {
            //     var el = document.querySelector('#row_task_' + task_id);
            //     // DOMをクローンしておく
            //     var el_clone = el.cloneNode(true);
            //     // 未完了の方を先に非表示にする
            //     el.classList.add('display_none');
            //     // もろもろスタイルなどをたして完了済みに追加
            //     el_clone.getElementsByTagName('input')[0].checked = 'checked';
            //     el_clone.getElementsByTagName('label')[0].classList.add('line-through');
            //     el_clone.getElementsByTagName('label')[0].classList.remove('word-color-black');
            //     var li = document.querySelector('#finished-tasks > ul > li:first-child');
            //     document.querySelector('#finished-tasks > ul').insertBefore(el_clone, li);
            // }
        }
    }
</script>

<style scoped>

</style>