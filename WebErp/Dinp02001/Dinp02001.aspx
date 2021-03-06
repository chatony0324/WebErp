﻿<%@ Page Title="" Language="C#" MasterPageFile="~/master/BaseMasterPage.master" AutoEventWireup="true" CodeFile="Dinp02001.aspx.cs" Inherits="Dinp02001_Dinp02001" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
         /* override multiselect default*/
        .app-body .multiselect__option--highlight
        {
            background: #3097D1;
            outline: none;
            color: white;
        }
        .app-body .multiselect__tags
        {
            border-color: #A8A8A8;
            border-radius: 0;
        }
        .app-body .multiselect
        {
            display: inline-block;
        }
        
        /* multiselect default end */
         .app-title {
             background-color: #3097D1;
             color: #FFF;
         }

        .app-body {
            padding-left: 5px;
        }

        .filter-div {
            margin-top: 5px;
        }

        .filter-div td,
        .editParam-div td {
            padding: 3px;
        }

        .no-margin {
            margin: 0 !important;
        }

        .no-padding {
            padding: 0 !important;
        }

        .scroll-table {
            width: 95%;
            max-height: 450px;
            overflow-y: auto;
            overflow-y: overlay;
            border: solid 1px #CCC;
        }

        .result-div {
            margin-top: 5px;
        }

        .table-bordered th, .table-bordered td {
            white-space: nowrap;
            padding-right: 18px!important;
        }

        #TotalTable th.orderby {
            font-weight: bold;
            color: #31ff00;
            text-decoration: underline;
        }

        #TotalTable th:hover {
            cursor: pointer;
        }

        .filter-div > table .ref-inputs > input:nth-child(odd),
        .editParam-div > table .ref-inputs > input:nth-child(odd) {
            width: 50px;
        }

        .filter-div > table .ref-inputs > input:nth-child(even),
        .editParam-div > table .ref-inputs > input:nth-child(even) {
            width: 70px;
        }

        .rowclass:hover {
            background-color: #bde7ff;
        }

        tr.selected-row {
            background: #AAE;
        }
      
        .filter-div .medium-field,
         .editParam-div .medium-field
         {
             width: 175px;
         }
        .filter-div .small-field,
        .editParam-div .small-field
        {
            width: 100px;
        }
        .filter-div .x-small-field,
        .editParam-div .x-small-field
        {
            width: 50px;
        }
    </style>
    <script>
        (function () {
            requirejs.config({
                //urlArgs: "NoCach=" + (new Date()).getTime(),
                paths: {
                    "Dinp02001": "Dinp02001/dinp02001"

                }

            });

            var requiredFiles = ["Dinp02001"];

            function onLoaded(Dinp02001) {


            }

            function onError(error) {
                console.error(error);
            }

            require(requiredFiles, onLoaded, onError);



        })();

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="dinp02001">
    </div>


</asp:Content>

