<%@ Control Language="c#" Inherits="ArenaWeb.WebControls.custom.Luminate.grapesJS_html" CodeFile="grapseJS_html.ascx.cs" %>
<asp:Panel ID="pnlEditImage" Runat="server" CssClass="editImage" Visible="False"><asp:ImageButton ID="ibEdit" ImageUrl="~Images/edit.gif" Runat="server" CausesValidation="False"></asp:ImageButton></asp:Panel>
<asp:PlaceHolder id="HtmlHolder" runat="server"></asp:PlaceHolder>
<asp:Panel ID="pnlEdit" Runat="server" CssClass="editWrap" Visible="False">
    <Arena:KeepAlive ID="keepMeAlive" runat="server" />
    <!-- GrapesJS here? -->
    <link rel="stylesheet" href="//unpkg.com/grapesjs/dist/css/grapes.min.css">
    <script src="//unpkg.com/grapesjs"></script>
    <style media="screen">
        /* Let's highlight canvas boundaries */
        #gjs {
          border: 3px solid #444;
        }

        /* Reset some default styling */
        .gjs-cv-canvas {
          top: 0;
          width: 100%;
          height: 100%;
        }

        .gjs-block {
          width: auto;
          height: auto;
          min-height: auto;
        }
    </style>
    <div id="gjs">
        <asp:PlaceHolder id="HtmlEditHolder" runat="server"></asp:PlaceHolder>
    </div>
    <div id="blocks"></div>
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
          storageManager: true,
          // Avoid any default panel
          panels: { defaults: [] },
          blockManager: {
            appendTo: '#blocks',
            blocks: [
              {
                id: 'section', // id is mandatory
                label: '<b>Section</b>', // You can use HTML/SVG inside labels
                attributes: { class:'gjs-block-section' },
                content: `<section>
                  <h1>This is a simple title</h1>
                  <div>This is just a Lorem text: Lorem ipsum dolor sit amet</div>
                </section>`,
              }, {
                id: 'text',
                label: 'Text',
                content: '<div data-gjs-type="text">Insert your text here</div>',
              }, {
                id: 'image',
                label: 'Image',
                // Select the component once it's dropped
                select: true,
                // You can pass components as a JSON instead of a simple HTML string,
                // in this case we also use a defined component type `image`
                content: { type: 'image' },
                // This triggers `active` event on dropped components and the `image`
                // reacts by opening the AssetManager
                activate: true,
              }
            ]
          },
          storageManager: {
              id: 'gjs-',             // Prefix identifier that will be used inside storing and loading
              type: 'remote',          // Type of the storage
              autosave: false,         // Store data automatically
              autoload: true,         // Autoload stored data on init
              //stepsBeforeSave: 1,     // If autosave enabled, indicates how many changes are necessary before store method is triggered
              storeComponents: true,  // Enable/Disable storing of components in JSON format
              storeStyles: true,      // Enable/Disable storing of rules in JSON format
              storeHtml: true,        // Enable/Disable storing of components as HTML string
              storeCss: true,         // Enable/Disable storing of rules as CSS string
              urlStore: 'https://portal.luminate.church/default.aspx?page=<%= Request["page"] %>&moduleID=<%= moduleID %>',
              urlLoad: 'https://portal.luminate.church/default.aspx?page=<%= Request["page"] %>&moduleID=<%= moduleID %>'

            }
        });
    </script>

    <asp:Button ID="btnSave" runat="server" CssClass="smallText" OnClick="btnSave_Click" Text="Save" CausesValidation="false" />
    <asp:Button ID="btnCancel" runat="server" CssClass="smallText" OnClick="btnCancel_Click" Text="Cancel"  CausesValidation="false"/>
</asp:Panel>
