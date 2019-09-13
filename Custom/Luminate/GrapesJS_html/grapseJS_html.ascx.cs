namespace ArenaWeb.WebControls.custom.Luminate
{
	using System;
	using System.Web.UI;

	using Arena.Content;
	using Arena.Core;
	using Arena.Core.Communications;
	using Arena.Exceptions;
	using Arena.Portal;
	using Arena.Security;
	using Arena.Utility;
	//using Telerik.Web.UI; //removed

	/// <summary>
	///		Summary description for HtmlText.
	/// </summary>
	//public abstract class HtmlText : System.Web.UI.UserControl
	public partial class grapesJS_html : PortalControl
    {
        private string editorScheme = string.Empty;
        private string flashPaths = string.Empty;
        private string mediaPaths = string.Empty;
        private string documentPaths = string.Empty;

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


		#endregion

		private bool editEnabled = false;
        private string htmlSource = string.Empty;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            editEnabled = CurrentModule.Permissions.Allowed(OperationType.Edit, CurrentUser) && EnableEditingSetting.Equals("true");

            htmlSource = CurrentModule.Details.Trim();

            ShowView();
        }

        private void ShowView() //no change
        {
            pnlEditImage.Visible = editEnabled;
            ibEdit.Visible = editEnabled;
            pnlEdit.Visible = false;

            ibEdit.ImageUrl = "~/Images/edit_no_shadow.gif";

            HtmlHolder.Controls.Clear();

            try
            {
                string HtmlContents = Server.HtmlDecode(htmlSource);

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
            HtmlHolder.Visible = false;
            pnlEdit.Visible = true;

			//edditor here?
            //radEditor.Content = Server.HtmlDecode(htmlSource); //this calles the htmlSource code

        }

        private void ibEdit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            ShowEdit();

            // set styles for rich textbox

            HtmlHolder.Visible = false;
            ibEdit.Visible = false;
            pnlEdit.Visible = true;
        }

        protected void lbCancel_Click(object sender, EventArgs e)
        { }
        protected void lbUpdate_Click(object sender, EventArgs e)
        { }

        protected void btnCancel_Click(object sender, System.EventArgs e)
        {
            ShowView();
        }

        protected void btnSave_Click(object sender, System.EventArgs e)
        {

			/*
			CurrentModule.Details = Server.HtmlEncode(radEditor.Content); //this part saves the HTML to
			CurrentModule.Save(CurrentUser.Identity.Name);
			htmlSource = CurrentModule.Details.Trim();
			*/
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
