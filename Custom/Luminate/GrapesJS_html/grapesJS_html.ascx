<%@ Control Language="c#" Inherits="ArenaWeb.WebControls.custom.Luminate.grapesJS_html" CodeFile="grapseJS_html.ascx.cs" %>
<asp:Panel ID="pnlEditImage" Runat="server" CssClass="editImage" Visible="False"><asp:ImageButton ID="ibEdit" ImageUrl="~Images/edit.gif" Runat="server" CausesValidation="False"></asp:ImageButton></asp:Panel>
<asp:PlaceHolder id="HtmlHolder" runat="server"></asp:PlaceHolder>
<asp:Panel ID="pnlEdit" Runat="server" CssClass="editWrap" Visible="False">
    <Arena:KeepAlive ID="keepMeAlive" runat="server" />
    <!-- GrapesJS here? -->
    <asp:Button ID="btnSave" runat="server" CssClass="smallText" OnClick="btnSave_Click" Text="Save" CausesValidation="false" />
    <asp:Button ID="btnCancel" runat="server" CssClass="smallText" OnClick="btnCancel_Click" Text="Cancel"  CausesValidation="false"/>
</asp:Panel>
