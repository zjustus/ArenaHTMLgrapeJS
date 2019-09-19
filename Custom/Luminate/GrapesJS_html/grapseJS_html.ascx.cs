namespace ArenaWeb.WebControls.custom.Luminate
{
	using System;
	using System.IO;
	using System.Web;
	using System.Web.UI;
	using System.Web.Script;
	using System.Collections.Generic;
	using Newtonsoft.Json.Linq;

	using Arena.Content;
	using Arena.Core;
	using Arena.Core.Communications;
	using Arena.Exceptions;
	using Arena.Portal;
	using Arena.Security;
	using Arena.Utility;

	/// <summary>
	///		This module is an HTML edditor for Shelby Arena. It uses GrapesJS to power it!
	/// </summary>
	//public abstract class HtmlText : System.Web.UI.UserControl
	public partial class grapesJS_html : PortalControl
    {
		public int moduleID = -1;
		public string[] ImageArray;
		public string[] FlashArray;
		public string[] MediaAray;
		public string[] DocumentArray;


        #region Module Settings

		[MultiTenantIgnore]
        [TextSetting("Image Paths", "Comma delimited list of image directories. If not provided then path in the web.config used.", false)]
        public string ImagesPathsSetting { get { return Setting("ImagesPaths", string.Empty, false); } }

		[MultiTenantIgnore]
        [TextSetting("Flash Paths", "Comma delimited list of flash directories. If not provided then path in the web.config used.", false)]
        public string FlashPathsSetting { get { return Setting("FlashPaths", string.Empty, false); } }

		[MultiTenantIgnore]
        [TextSetting("Media Paths", "Comma delimited list of media directories. If not provided then path in the web.config used.", false)]
        public string MediaPathsSetting { get { return Setting("MediaPaths", string.Empty, false); } }

		[MultiTenantIgnore]
        [TextSetting("Document Paths", "Comma delimited list of document directories. If not provided then path in the web.config used.", false)]
        public string DocumentPathsSetting { get { return Setting("DocumentPaths", string.Empty, false); } }

        [TextSetting("Notify", "List of e-mail addresses to notify when content is changed (multiple e-mails can be provided when separated by a semi-colon.)", false)]
        public string NotifySetting { get { return Setting("Notify", string.Empty, false); } }

        [BooleanSetting("Evaluate Query String", "Flag indicating if occurrences of ##[QUERYSTRING_PARAMETER]## should be replaced with the value of the specified Query String parameter.", false, false)]
        public string EvaluateQueryStringSetting { get { return Setting("EvaluateQueryString", "false", false); } }

        [NumericSetting("Editor Width", "Optional value for the width of the text editor.  Default = 580px", false)]
        public string EditorWidthSetting { get { return Setting("EditorWidth", "580", false); } }

        [NumericSetting("Editor Height", "Optional value for the height of the text editor.  Default = 550px", false)]
        public string EditorHeightSetting { get { return Setting("EditorHeight", "550", false); } }

        [BooleanSetting("Enable Editing", "Flag indicating if editor pencil should be displayed, which allows in place editing.", false, true)]
        public string EnableEditingSetting { get { return Setting("EnableEditing", "true", false); } }

		[BooleanSetting("Enable Auto Save", "Flag indicating if GrapeJS should auto save the webpage.", false, true)]
        public string AutoSaveSetting { get { return Setting("AutoSaveSetting", "true", false); } }

		[NumericSetting("Steps Before Saving", "Optional value for the steps before auto save.  Default is 1", false)]
        public string saveStepsSetting { get { return Setting("saveStepsSetting", "1", false); } }

		#endregion

		private bool editEnabled = false;
        private string htmlSource = string.Empty;


        protected void Page_Load(object sender, System.EventArgs e)
        {
			editEnabled = CurrentModule.Permissions.Allowed(OperationType.Edit, CurrentUser) && EnableEditingSetting.Equals("true");
			htmlSource = CurrentModule.Details.Trim();
			moduleID = CurrentModule.ModuleInstanceID;

			//needs to set file arrays here
			ImageArray = filesInPath(ImagesPathsSetting, "Content/HtmlImages/Public/Images/General/");
			FlashArray = filesInPath(FlashPathsSetting, "Content/HtmlImages/Public/Flash/General");
			MediaAray = filesInPath(MediaPathsSetting, "Content/HtmlImages/Public/Media/General/");
			DocumentArray = filesInPath(DocumentPathsSetting, "Content/HtmlImages/Public/Documents/General/");

			if (Request.IsAuthenticated && editEnabled) {
				if(Request.HttpMethod.ToString() == "POST" && Request["moduleID"] == moduleID.ToString()){ //Save the data
					Response.Clear();
					Response.ContentType = "application/json; charset=utf-8";

					//grabes the JSON as a string and converts to JSON object
					var bodyStream = new StreamReader(HttpContext.Current.Request.InputStream);
    				bodyStream.BaseStream.Seek(0, SeekOrigin.Begin);
    				var bodyText = bodyStream.ReadToEnd();
					var json = JObject.Parse(bodyText);
					string jsonString = bodyText;

					string jHtml = (string)json.GetValue("gjs-html");

					if(!string.IsNullOrEmpty(jsonString)){
						CurrentModule.Details = Server.HtmlEncode(jsonString);
						CurrentModule.Save(CurrentUser.Identity.Name);
					}

					Response.Write("Saved");
					Response.End();



				}
				else if(Request.HttpMethod.ToString() == "GET" && Request["moduleID"] == moduleID.ToString()){ //Load the data
					string json = Server.HtmlDecode(htmlSource);
					Response.Clear();
					Response.ContentType = "application/json; charset=utf-8";
					Response.Write(json);
					Response.End();
				}
			}
	        ShowView();
        }

        private void ShowView()
        {
            pnlEditImage.Visible = editEnabled;
            ibEdit.Visible = editEnabled;
            pnlEdit.Visible = false;

            ibEdit.ImageUrl = "~/Images/edit_no_shadow.gif";

            HtmlHolder.Controls.Clear();
            try
            {
				string HtmlContents = string.Empty;
				if(!string.IsNullOrEmpty(htmlSource)){
					//convert from encode to decode then parses to a json object
					var jDetails = JObject.Parse(Server.HtmlDecode(htmlSource));
					HtmlContents = string.Format("<Style>{0}</style>", (string)jDetails.GetValue("gjs-css"));
					HtmlContents += (string)jDetails.GetValue("gjs-html");
				}
				else HtmlContents = "";

                if (Boolean.Parse(EvaluateQueryStringSetting))
                {
                    string[] keys;
                    keys = Request.QueryString.AllKeys;
                    foreach (string key in keys)
                        HtmlContents = HtmlContents.Replace("##" + key.ToUpper() + "##", Request.QueryString.Get(key));
                }

                HtmlHolder.Controls.Add(new LiteralControl(HtmlContents));
                HtmlHolder.Visible = true;

            }
            catch (System.Exception ex)
            {
                throw new ModuleException(CurrentPortalPage, CurrentModule, string.Format("Could not load the HTML from the '{0}' control.", CurrentModule.Title), ex);
            }
        }

        private void ShowEdit()
        {
            ibEdit.Visible = false;
            HtmlHolder.Visible = false; //changed from false to true
            pnlEdit.Visible = true;

			try
            {
				string HtmlContents = string.Empty;
				if(!string.IsNullOrEmpty(htmlSource)){
					//convert from encode to decode then parses to a json object
					var jDetails = JObject.Parse(Server.HtmlDecode(htmlSource));
					HtmlContents = (string)jDetails.GetValue("gjs-html");
				}
				else HtmlContents = "";

				HtmlHolder.Visible = false;
            }
            catch (System.Exception ex)
            {
                throw new ModuleException(CurrentPortalPage, CurrentModule, string.Format("Could not load the HTML from the '{0}' control.", CurrentModule.Title), ex);
            }
        }

		private string[] filesInPath(string FilePathSetting, string FilePathDefault){
			List<string> FileList = new List<string>();
			string[] fileArray;
			string ArenaPath = "/Program Files (x86)/Arena ChMS/Arena/";
			string FilePath = ArenaPath;
			if(!string.IsNullOrEmpty(FilePathSetting)){ FilePath += FilePathSetting; }
			else{ FilePath += FilePathDefault; }
			try{
				var FileDirectory = Directory.EnumerateFiles(FilePath);
				foreach(string file in FileDirectory){
					FileList.Add(file.Replace(ArenaPath, CurrentPortal.Domain));
				}
				fileArray = FileList.ToArray();
			}
			catch(System.Exception ex){
				throw new ModuleException(CurrentPortalPage, CurrentModule, string.Format("Could not load the HTML from the '{0}' control.", CurrentModule.Title), ex);
			}
			return fileArray;
		}

        private void ibEdit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            ShowEdit();

            // set styles for rich textbox
            HtmlHolder.Visible = false;
            ibEdit.Visible = false;
            pnlEdit.Visible = true;
        }

        protected void btnFinish_Click(object sender, System.EventArgs e)
        {
            ShowView();
			try
            {
                if (NotifySetting != string.Empty)
                {
                    char[] splitter = { ';' };

                    string[] emails = NotifySetting.Split(splitter);

                    if (emails.Length > 0)
                    {
                        AdvancedHTML htmlEmail = new AdvancedHTML();
                        System.Collections.Generic.Dictionary<string, string> fields = new System.Collections.Generic.Dictionary<string, string>();
                        fields.Add("##PageName##", CurrentPortalPage.Name);
                        fields.Add("##PageID##", CurrentPortalPage.PortalPageID.ToString());
                        fields.Add("##ContentArea##", CurrentModule.TemplateFrameName);
                        fields.Add("##ModuleName##", CurrentModule.Title);
                        fields.Add("##UserID##", CurrentUser.Identity.Name);
                        fields.Add("##Link##", "http://" + Request.Url.Host + "/default.aspx?page=" + CurrentPortalPage.PortalPageID.ToString());
                        foreach (string email in emails)
                        {
                            htmlEmail.Send(email, fields);
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                throw new ArenaApplicationException("Error occurred during while trying to send notification of your content changes.", ex);
            }
        }

        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        ///		Required method for Designer support - do not modify
        ///		the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ibEdit.Click += new System.Web.UI.ImageClickEventHandler(this.ibEdit_Click);

        }
        #endregion
    }
}
