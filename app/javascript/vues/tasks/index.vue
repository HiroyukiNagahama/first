<template>
    <div>
        <!-- 新規作成部分 -->
        <div class="row">
            <div class="col-xs-10 col-md-11">
                <input v-model="newTask" class="form-control" placeholder="Add your task!!">
            </div>
            <div class="col-xs-2 col-md-1">
                <div class="btn-floating waves-effect waves-light red btn" v-on:click="createTask()">
                    <i class="material-icons">add</i>
                </div>
            </div>
        </div>
        <!-- リスト表示部分 -->
        <div>
            <table class="table">
                <thead><th>c</th><th>c</th></thead>
                <tbody>
                <tr v-for="task in tasks" v-if="!task.is_done" v-bind:id="'row_task_' + task.id" class="collection-item">
                    <td><input type="checkbox" v-on:change="doneTask(task.id)" v-bind:id="'task_' + task.id" /></td>
                    <td v-bind:for="'task_' + task.id">{{ task.name }}</td>
                </tr>
                </tbody>
            </table>

        </div>
        <!-- 完了済みタスク表示ボタン -->
        <div class="btn" v-on:click="displayFinishedTasks">Display finished tasks</div>
        <!-- 完了済みタスク一覧 -->
        <div>
        <table class="table table-dark">
            <thead><th>c</th><th>c</th></thead>
            <tbody id="finished-tasks" class="display_none">
            <tr v-for="task in tasks" v-if="task.is_done"v-bind:id="'row_task_' + task.id" class="collection-item">
                <td><input type="checkbox" v-bind:id="'task_' + task.id" checked="checked" /></td>
                <td v-bind:for="'task_' + task.id"  class="line-through">{{ task.name }}</td>
            </tr>
            </tbody>
        </table>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';
    axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

    export default {
        data: function () {
            return {
                tasks: [],
                newTask: ''
            }
        },
        mounted: function () {
            this.fetchTasks();
        },
        methods: {
            fetchTasks: function () {
                axios.get('/api/task_api').then((response) => {
                    console.log(response.data)
                    for (var i = 0; i < response.data.length; i++) {
                        this.tasks.push(response.data[i]);
                    }
                }, (error) => {
                    console.log(error);
                });
            },
            displayFinishedTasks: function() {
                document.querySelector('#finished-tasks').classList.toggle('display_none');
            },
            createTask: function () {
                console.log('hogez')
                if (!this.newTask) return;

                axios.post('/api/task_api', { task: { name: this.newTask } }).then((response) => {
                    this.tasks.unshift(response.data);
                    this.newTask = '';
                }, (error) => {
                    console.log(error);
                });
            },
            doneTask: function (task_id) {
                axios.put('/api/tasks/' + task_id, { task: { is_done: 1 } }).then((response) => {
                    this.moveFinishedTask(task_id);
                }, (error) => {
                    console.log(error);
                });
            },
            moveFinishedTask: function(task_id) {
                var el = document.querySelector('#row_task_' + task_id);
                // DOMをクローンしておく
                var el_clone = el.cloneNode(true);
                // 未完了の方を先に非表示にする
                el.classList.add('display_none');
                // もろもろスタイルなどをたして完了済みに追加
                el_clone.getElementsByTagName('input')[0].checked = 'checked';
                el_clone.getElementsByTagName('label')[0].classList.add('line-through');
                el_clone.getElementsByTagName('label')[0].classList.remove('word-color-black');
                var li = document.querySelector('#finished-tasks > ul > li:first-child');
                document.querySelector('#finished-tasks > ul').insertBefore(el_clone, li);
            }
        }
    }
</script>

<style scoped>
    [v-cloak] {
      display: none;
    }
    .display_none {
      display:none;
    }
    /* 打ち消し線を引く */
   .line-through {
     text-decoration: line-through;
   }
</style>