<%@ Control Language="c#" Inherits="ArenaWeb.WebControls.custom.Luminate.grapesJS_html" CodeFile="grapseJS_html.ascx.cs" %>
<asp:Panel ID="pnlEditImage" Runat="server" CssClass="editImage" Visible="False"><asp:ImageButton ID="ibEdit" ImageUrl="~Images/edit.gif" Runat="server" CausesValidation="False"></asp:ImageButton></asp:Panel>
<asp:PlaceHolder id="HtmlHolder" runat="server"></asp:PlaceHolder>
<asp:Panel ID="pnlEdit" Runat="server" CssClass="editWrap" Visible="False">
    <Arena:KeepAlive ID="keepMeAlive" runat="server" />
    <!-- GrapesJS here? -->
    <link rel="stylesheet" href="//unpkg.com/grapesjs/dist/css/grapes.min.css">
    <script src="//unpkg.com/grapesjs"></script>
    <div id="gjs">
        <asp:PlaceHolder id="HtmlEditHolder" runat="server"></asp:PlaceHolder>
    </div>
    <script type="text/javascript">
        const editor = grapesjs.init({
          // Indicate where to init the editor. You can also pass an HTMLElement
          container: '#gjs',
          // Get the content for the canvas directly from the element
          // As an alternative we could use: `components: '<h1>Hello World Component!</h1>'`,
          fromElement: true,
          // Size of the editor
          height: '500px',
          width: 'auto',
          // Disable the storage manager for the moment
          storageManager: false,
          // Avoid any default panel
          panels: { defaults: [] },
        });
    </script>

    <asp:Button ID="btnSave" runat="server" CssClass="smallText" OnClick="btnSave_Click" Text="Save" CausesValidation="false" />
    <asp:Button ID="btnCancel" runat="server" CssClass="smallText" OnClick="btnCancel_Click" Text="Cancel"  CausesValidation="false"/>
</asp:Panel>
