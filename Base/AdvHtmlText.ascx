<%@ Control Language="c#" Inherits="ArenaWeb.WebControls.AdvHtmlText" CodeFile="AdvHtmlText.ascx.cs" %>
<%@ Register TagPrefix="Telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
    <asp:Panel ID="pnlEditImage" Runat="server" CssClass="editImage" Visible="False"><asp:ImageButton ID="ibEdit" ImageUrl="~Images/edit.gif" Runat="server" CausesValidation="False"></asp:ImageButton></asp:Panel>
    <asp:PlaceHolder id="HtmlHolder" runat="server"></asp:PlaceHolder>
    <asp:Panel ID="pnlEdit" Runat="server" CssClass="editWrap" Visible="False">
        <Arena:KeepAlive ID="keepMeAlive" runat="server" />
        <Telerik:RadEditor ID="radEditor" runat="server" ImageAllowedFileTypes="gif,png,bmp,jpg" />
            <asp:Button ID="btnSave" runat="server" CssClass="smallText" OnClick="btnSave_Click" Text="Save" CausesValidation="false" />
        <asp:Button ID="btnCancel" runat="server" CssClass="smallText" OnClick="btnCancel_Click" Text="Cancel"  CausesValidation="false"/>
    </asp:Panel>
