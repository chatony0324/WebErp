﻿'use strict';
(function () {
    requirejs.config({
        paths: {
            "functionButton": isIE ? "VueComponent/FunctionButton.babel" : "VueComponent/FunctionButton",
            "uibPagination": "public/scripts/VueComponent/vuejs-uib-pagination",
            "vueDatetimepicker": isIE ? "public/scripts/VueComponent/vue-jQuerydatetimepicker.babel" : "public/scripts/VueComponent/vue-jQuerydatetimepicker",
            "jqueryDatetimepicker": "public/scripts/jquery.datetimepicker/jquery.datetimepicker.full",
            "jqueryDatetimepicker-css": "public/scripts/jquery.datetimepicker/jquery.datetimepicker",
            "jquery-mousewheel": "public/scripts/jquery.mousewheel.min",
        },
        shim: {
            "jqueryDatetimepicker": {
                "deps": ["css!jqueryDatetimepicker-css"]
            },
            "vueDatetimepicker": {
                "deps": ['jqueryDatetimepicker']
            },
        }
    });
    var requiredFiles = ["bootstrap", "functionButton", "uibPagination", "vueDatetimepicker", "LoadingHelper", "UserLog"];


    function onLoaded(bootstrap, functionButton, uibPagination, vueDatetimepicker, loadingHelper) {

        window.Dsap02005 = new Vue({
            el: "#content",
            data: {
                IsCheckAll: false,
                Filter: {
                    Name: "",
                    DateStart: "",
                    DateEnd: ""

                },
                IsAddUser: false,
                UserInfo: {},
                UserInfoList: [],
                SortColumn: "",
                SortOrder: "",
            },
            methods: {
                Init: function () {

                },
                OnTableSorting: function (column, $event) {
                    var vueObj = this;
                    $($event.target).parents("tr:first").find("i").each(function () {
                        $(this).attr("class", "fa fa-fw fa-sort")
                    })
                    if (vueObj.SortColumn == column) {
                        if (vueObj.SortOrder == "asc") {
                            vueObj.SortOrder = "desc";
                            $($event.target).find("i").attr("class", "fa fa-fw fa-sort-down")
                        } else {
                            vueObj.SortOrder = "asc";
                            $($event.target).find("i").attr("class", "fa fa-fw fa-sort-up")
                        }
                    } else {
                        vueObj.SortOrder = "asc";
                        $($event.target).find("i").attr("class", "fa fa-fw fa-sort-up")
                    }



                    this.SortColumn = column;

                    vueObj.UserInfoList.sort(function (a, b) {

                        if (a[vueObj.SortColumn] < b[vueObj.SortColumn]) {
                            return vueObj.SortOrder == 'asc' ? -1 : 1;

                        }
                        if (a[vueObj.SortColumn] > b[vueObj.SortColumn]) {
                            return vueObj.SortOrder == 'asc' ? 1 : -1;
                        }
                        return 0;
                    });

                },
                OnSearch: function () {
                    var vueObj = this;
                    LoadingHelper.showLoading();

                    vueObj.SortColumn = "";
                    vueObj.SortOrder = "";
                    $(".sort-item").find("i").each(function () {
                        $(this).attr("class", "fa fa-fw fa-sort")
                    })

                    return $.ajax({
                        url: rootUrl + "Example/Ajax/GetData.ashx",
                        type: 'POST',
                        cache: false,
                        data: {
                            data: JSON.stringify(vueObj.Filter)
                        }, success: function (result) {
                            LoadingHelper.hideLoading();
                            vueObj.UserInfoList = JSON.parse(result);
                            if (vueObj.UserInfoList.length == 0) {
                                alert("查無資料");
                            }


                        }, error: function (jqXhr, textStatus, errorThrown) {
                            if (jqXhr.status == 0) {
                                return;
                            }
                            LoadingHelper.hideLoading();
                            console.error(errorThrown);
                            alert("查詢失敗");
                        }
                    })

                },
                OpenModal: function (User) {
                    var vueObj = this;
                    if (vueObj.IsAddUser) {

                        vueObj.UserInfo = User;
                    } else {
                        vueObj.UserInfo = {
                            Id: User.Id,
                            Name: User.Name,
                            PassWord: User.PassWord,
                            Email: User.Email,
                            UpdateTime: User.UpdateTime,
                        }

                    }
                    $("#myModal").modal("show");

                }, OnSubmit: function () {
                    var vueObj = this;

                    if (!confirm("確定送出資料?")) {
                        return;
                    }
                    return $.ajax({
                        url: rootUrl + "Example/Ajax/SubmitData.ashx",
                        type: 'POST',
                        cache: false,
                        data: {
                            act: (vueObj.IsAddUser ? "Add" : "Edit"),
                            data: JSON.stringify(vueObj.UserInfo),
                            loginUserName: loginUserName,
                        },
                        success: function (result) {
                            if (result == "ok") {
                                alert("成功");

                                vueObj.OnSearch();


                                $("#myModal").modal("hide");
                            } else {
                                console.log(result);
                                alert("失敗");
                            }

                        },
                        error: function (jqXhr, textStatus, errorThrown) {
                            if (jqXhr.status == 0) {
                                return;
                            }
                            console.error(errorThrown);
                            alert("失敗");
                        }
                    });

                    $("#myModal").modal();
                },
                OnDelete: function () {
                    var vueObj = this;
                    var datalist = [];

                    for (var i in vueObj.UserInfoList) {
                        if (vueObj.UserInfoList[i].checked) {
                            datalist.push(vueObj.UserInfoList[i]);
                        }
                    }
                    if (datalist.length == 0) {
                        alert("沒有選擇要刪除的資料");
                    }

                    if (!confirm("確定刪除所選資料?")) {
                        return;
                    }
                    return $.ajax({
                        url: rootUrl + "Example/Ajax/DeleteData.ashx",
                        type: 'POST',
                        cache: false,
                        data: {
                            datalist: JSON.stringify(datalist),
                            loginUserName: loginUserName,
                        },
                        success: function (result) {
                            if (result == "ok") {
                                alert("成功");
                                vueObj.OnSearch();
                            } else {
                                console.log(result);
                                alert("失敗");
                            }

                        },
                        error: function (jqXhr, textStatus, errorThrown) {
                            if (jqXhr.status == 0) {
                                return;
                            }
                            console.error(errorThrown);
                            alert("失敗");
                        }
                    });


                }, OnCheckAll: function () {
                    Vue.nextTick(function () {
                        for (var i in ExampleJs.UserInfoList) {
                            ExampleJs.UserInfoList[i].checked = ExampleJs.IsCheckAll;
                        }
                    });
                }
            }, computed: {

            }
        })
    }

    function onError(error) {
        console.error(error);
    }

    define(requiredFiles, onLoaded, onError);
})();