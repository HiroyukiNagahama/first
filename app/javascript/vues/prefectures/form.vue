<template>
  <table class="table table-dark">
    <div>

    </div>

  </table>
</template>

<script>
    import axios from 'axios';
    axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

    export default {
        data: function () {
            return {
                prefecture: {},
            }
        },
        mounted: function (prefecture_id) {
            this.fetchPrefecture(prefecture_id);
        },
        methods: {
            fetchPrefectures: function () {
                axios.get('/prefectures/edit_vue').then((response) => {
                    if (response.data == null) {
                        alert('noData')
                    }
                     this.prefecture = response.data;
                }, (error) => {
                    console.log(error);
                    alert('Error')
                });
            },
        }
    }
</script>