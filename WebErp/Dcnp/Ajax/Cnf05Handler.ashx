﻿<%@ WebHandler Language="C#" Class="Cnf05Handler" %>

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.SessionState;
using DCNP005;
using Newtonsoft.Json;

public class Cnf05Handler : IHttpHandler, IRequiresSessionState
{

    /// <summary>
    /// Request.Form["act"]
    /// </summary>
    public string Action { get; set; }
    /// <summary>
    /// Request.Form["data"]
    /// </summary>
    public string Data { get; set; }
    /// <summary>
    /// Request.Form["type"]
    /// </summary>
    public string Type { get; set; }
    /// <summary>
    /// Request.Form["fields"]
    /// </summary>
    public string FieldNames { get; set; }

    /// <summary>
    /// Request.Params["user"]
    /// </summary>
    public string User { get; set; }

    public void ProcessRequest (HttpContext context)
    {
        this.Action = context.Request.Form["act"];
        this.Data = context.Request.Form["data"];
        this.Type = context.Request.Form["type"];
        this.FieldNames = context.Request.Form["fields"];
        this.User = context.Request.Params["user"];
        
        if (context.Request.Files.Count > 0)
        {
            this.Action = "import";
        }
        
        if (this.Action == null) return;
        switch (this.Action.ToLower())
        {
            case "add":
                {
                    Cnf05 cnf05 = JsonConvert.DeserializeObject<Cnf05>(this.Data);
                    try
                    {
                        var newItem = Cnf05.AddItem(cnf05);
                        if (newItem == null)
                        {
                            throw new Exception("Add Cnf05 fail.");
                        }
                        context.Response.ContentType = "text/plain";
                        context.Response.Write(JsonConvert.SerializeObject(newItem));
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Message.Contains("insert duplicate key"))
                        {
                            context.Response.ContentType = "text/plain";
                            context.Response.Write("insert duplicate key");
                        }
                        else
                        {
                            throw;
                        }
                    }
                    
                    return;
                }
                break;
            case "get":
                {
                    Cnf05.FilterOption filterOption = JsonConvert.DeserializeObject<Cnf05.FilterOption>(this.Data);
                    var cnf05List = Cnf05.Search(filterOption);
                    context.Response.ContentType = "text/plain";
                    context.Response.Write(JsonConvert.SerializeObject(cnf05List));
                    return;
                }
                break;
            case "update":
                {
                    Cnf05 cnf05 = JsonConvert.DeserializeObject<Cnf05>(this.Data);
                    var newItem = Cnf05.UpdateItem(cnf05);
                    if (newItem == null)
                    {
                        Cnf05.FilterOption a;
                        throw new Exception("Update Cnf05 fail.");
                    }
                }
                break;
            case "batchupdate":
                {
                    List<Cnf05> cnf05List = JsonConvert.DeserializeObject<List<Cnf05>>(this.Data);
                    var newItem = Cnf05.BatchUpdateItem(cnf05List);
                    if (newItem == null)
                    {
                        Cnf05.FilterOption a;
                        throw new Exception("BatchUpdate Cnf05List fail.");
                    }
                }
                break;
            case "del":
                {
                    var success = false;
                    if (String.Equals("list", this.Type))
                    {
                        success = Cnf05.DeleteItem(JsonConvert.DeserializeObject<int[]>(this.Data));
                    }
                    else
                    {
                        success = Cnf05.DeleteItem(Convert.ToInt32(this.Data));
                    }
                    
                    if (!success)
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write("fail");
                        return;
                    }
                }
                break;
            case "export":
                {
                    var fieldNameList = JsonConvert.DeserializeObject<string[]>(this.FieldNames);
                    List<Cnf05> cnf05List = JsonConvert.DeserializeObject<List<Cnf05>>(this.Data);
                    context.Session["exportFields"] = fieldNameList;
                    context.Session["exportItems"] = cnf05List;
                    context.Session["exportExcelVersion"] = 2003;
                }
                break;
            case "import":
                {
                    byte[] b = new byte[context.Request.Files[0].InputStream.Length];
                    if (b.Length == 0)
                    {
                        throw new Exception("File can not be empty");
                    }
                    context.Request.Files[0].InputStream.Read(b, 0, b.Length);
                    List<Cnf05> cnf05List = null;
                    using (MemoryStream stream = new MemoryStream(b))
                    {
                        cnf05List = Cnf05.ParseFromExcel(stream, this.User);
                    }
                    if (cnf05List != null && cnf05List.Count > 0)
                    {
                        for (var i = 0; i < cnf05List.Count;i++ )
                        {
                            var cnf05 = cnf05List[i];
                            //re-add item on processing import data
                            try
                            {
                                Cnf05.DeleteItemByUniqueColumns(cnf05.cnf0501_file, cnf05.cnf0502_field);
                                Cnf05.AddItem(cnf05);
                            }
                            catch (Exception ex)
                            {
                                context.Response.ContentType = "text/plain";
                                context.Response.Write(String.Format("{0}, 請檢查第{1}列", ex.Message, i + 1));
                                return;
                            }
                        }
                    }
                }
                break;
            default:
                {
                    
                }
                break;
        }
        
        context.Response.ContentType = "text/plain";
        context.Response.Write("ok");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}