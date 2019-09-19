<%@ Control Language="c#" Inherits="ArenaWeb.WebControls.custom.Luminate.grapesJS_html" CodeFile="grapseJS_html.ascx.cs" %>
<asp:Panel ID="pnlEditImage" Runat="server" CssClass="editImage" Visible="False"><asp:ImageButton ID="ibEdit" ImageUrl="~Images/edit.gif" Runat="server" CausesValidation="False"></asp:ImageButton>
</asp:Panel>
<asp:PlaceHolder id="HtmlHolder" runat="server"></asp:PlaceHolder>
<asp:Panel ID="pnlEdit" Runat="server" CssClass="editWrap" Visible="False">
    <Arena:KeepAlive ID="keepMeAlive" runat="server" />
    <link rel="stylesheet" href="//unpkg.com/grapesjs/dist/css/grapes.min.css">
    <script src="//unpkg.com/grapesjs"></script>
    <style media="screen">
        /* Let's highlight canvas boundaries */
        #gjs {
          border: 3px solid #444;
         height: 300px !important;
        }

        /* Reset some default styling */
        .gjs-cv-canvas {
          top: 0;
          width: 100%;
          height: 80vh;
        }

        .gjs-block {
          width: auto;
          height: auto;
          min-height: auto;
        }

        .panel__top {
          padding: 0;
          width: 100%;
          display: flex;
          position: initial;
          justify-content: center;
          justify-content: space-between;
        }
        .panel__basic-actions {
          position: initial;
        }

        .editor-row {
          display: flex;
          justify-content: flex-start;
          align-items: stretch;
          flex-wrap: nowrap;
          height: 80vh;
        }

        .editor-canvas {
          flex-grow: 1;
        }

        .panel__right {
          flex-basis: 230px;
          position: relative;
          overflow-y: auto;
        }

        .panel__switcher {
          position: initial;
        }

        .panel__devices {
          position: initial;
        }

    </style>
    <div class="panel__top"> <!-- top pannel -->
        <div class="panel__devices"></div>
        <div class="panel__basic-actions"></div>
        <div class="panel__switcher"></div>
    </div>
    <div class="editor-row">
      <div class="editor-canvas"> <!-- main edditor -->
        <div id="gjs">...</div>
      </div>
      <div class="panel__right"> <!-- right pannel -->
      <div class="blocks-container" id="blocks"></div>
      <div class="styles-container"></div>
        <div class="layers-container"></div>
      </div>
    </div>
    <script type="text/javascript">
        const editor = grapesjs.init({
          container: '#gjs',
          fromElement: true,
          height: '80vh',
          width: 'auto',
          storageManager: true,
          blockManager: {
            appendTo: '#blocks',
            blocks: [
              {
                id: 'column1', // id is mandatory
                label: '<b>1 Column</b>', // You can use HTML/SVG inside labels
                attributes: { class:'gjs-block-section' },
                content:'<div class="container-fluid" data-gjs-custom-name="Container">'+
                        '<div class="row" data-gjs-custom-name="Row">'+
                            '<div class="col-12" data-gjs-custom-name="Column">'+
                                '<p>this is the column</p>'+
                            '</div>'+
                        '</div>'+
                    '</div>'
                ,
              },
              {
                id: 'column2', // id is mandatory
                label: '<b>2 Columns</b>', // You can use HTML/SVG inside labels
                attributes: { class:'gjs-block-section' },
                content: '<div class="container-fluid" data-gjs-custom-name="Container">'+
                        '<div class="row" data-gjs-custom-name="Row">'+
                            '<div class="col-6" data-gjs-custom-name="Column">'+
                                '<p>this is the COlumn</p>'+
                            '</div>'+
                            '<div class="col-6" data-gjs-custom-name="Column">'+
                                '<p>this is second Column</p>'+
                            '</div>'+
                        '</div>'+
                    '</div>'
                ,
              },
              {
                id: 'column3', // id is mandatory
                label: '<b>3 Columns</b>', // You can use HTML/SVG inside labels
                attributes: { class:'gjs-block-section' },
                content: '<div class="container-fluid" data-gjs-custom-name="Container">'+
                        '<div class="row" data-gjs-custom-name="Row">'+
                            '<div class="col-4" data-gjs-custom-name="Column">'+
                                '<p>this is the COlumn</p>'+
                            '</div>'+
                            '<div class="col-4" data-gjs-custom-name="Column">'+
                                '<p>this is second column</p>'+
                            '</div>'+
                            '<div class="col-4" data-gjs-custom-name="Column">'+
                                '<p>this is third column</p>'+
                            '</div>'+
                        '</div>'+
                    '</div>'
                ,
              },
              {
                id: 'text',
                label: 'Text',
                content: '<div data-gjs-type="text">Insert your text here</div>',
              }, {
                id: 'image',
                label: 'Image',
                select: true, // Select the component once it's dropped
                content: { type: 'image' },
                activate: true,
              }
            ]
          },
          layerManager: {
              appendTo: '.layers-container'
          },
          deviceManager: {
            devices: [{
                name: 'Desktop',
                width: '', // default size
              }, {
                name: 'Mobile',
                width: '320px', // this value will be used on canvas width
                widthMedia: '480px', // this value will be used in CSS @media
            },
            {
                name: 'Tablet',
                width: '500px',
                wudthMedia: '550px',
            }]
          },
          panels: {
            defaults: [
            {
                id: 'panel-switcher',
                el: '.panel__switcher',
                buttons: [{
                    id: 'show-layers',
                    active: true,
                    label: '<i class="fa fa-object-group" aria-hidden="true"></i>',
                    command: 'show-layers',
                    // Once activated disable the possibility to turn it off
                    togglable: false,
                  }, {
                    id: 'show-style',
                    active: true,
                    label: '<i class="fa fa-paint-brush" aria-hidden="true"></i>',
                    command: 'show-styles',
                    togglable: false,
                }, {
                    id: 'show-blocks',
                    active: true,
                    label: '<i class="fa fa-th-large" aria-hidden="true"></i>',
                    command: 'show-blocks',
                    togglable: false,
                }],
            }
            ,{
                id: 'layers',
                el: '.panel__right',
                // Make the panel resizable
                resizable: {
                    maxDim: 350,
                    minDim: 200,
                    tc: 0, // Top handler
                    cl: 1, // Left handler
                    cr: 0, // Right handler
                    bc: 0, // Bottom handler
                    // Being a flex child we need to change `flex-basis` property
                    // instead of the `width` (default)
                    keyWidth: 'flex-basis',
                },
            },
            {
                id: 'panel-devices',
                el: '.panel__devices',
                buttons: [{
                    id: 'device-desktop',
                    label: '<i class="fa fa-desktop" aria-hidden="true"></i>',
                    command: 'set-device-desktop',
                    active: true,
                    togglable: false,
                  }
                  ,{
                      id: 'device-tablet',
                      label: '<i class="fa fa-tablet" aria-hidden="true"></i>',
                      command: 'set-device-tablet',
                      togglable: false,
                  }
                  , {
                    id: 'device-mobile',
                    label: '<i class="fa fa-mobile" aria-hidden="true"></i>',
                    command: 'set-device-mobile',
                    togglable: false,
                  }
                 ],
            }]
            },
            selectorManager: {
                appendTo: '.styles-container'
              },
              styleManager: {
                appendTo: '.styles-container',
                sectors: [
                {
                    name: 'Background',
                    open: false,
                    buildProps: ['background-color', 'background-image'],
                },
                {
                    name: 'Dimension',
                    open: false,
                    // Use built-in properties
                    buildProps: ['width', 'min-height', 'padding'],
                    // Use `properties` to define/override single property
                    properties: [
                      {
                        // Type of the input,
                        // options: integer | radio | select | color | slider | file | composite | stack
                        type: 'integer',
                        name: 'The width', // Label for the property
                        property: 'width', // CSS property (if buildProps contains it will be extended)
                        units: ['px', '%'], // Units, available only for 'integer' types
                        defaults: 'auto', // Default value
                        min: 0, // Min value, available only for 'integer' types
                      }
                    ]
                  },{
                    name: 'Extra',
                    open: false,
                    buildProps: ['box-shadow', 'custom-prop'],
                    properties: [
                      {
                        id: 'custom-prop',
                        name: 'Custom Label',
                        property: 'font-size',
                        type: 'select',
                        defaults: '32px',
                        // List of options, available only for 'select' and 'radio'  types
                        options: [
                          { value: '12px', name: 'Tiny' },
                          { value: '18px', name: 'Medium' },
                          { value: '32px', name: 'Big' },
                        ],
                     }
                    ]
                  }]
              },
              traitManager: {
                  appendTo: '.styles-container',
              },

              AssetManager:{
                  //upload: '/upload endpoint', //code for later, this is where the assets upload to
                  //params: {}, //paramaters to pass in the upload
                  upload: 0,
              },
          storageManager: {
              id: 'gjs-',                   // Prefix identifier that will be used inside storing and loading
              type: 'remote',               // Type of the storage
              autosave: <%= AutoSaveSetting %>,
              autoload: true,
              stepsBeforeSave: <%= saveStepsSetting %>,
              storeComponents: true,
              storeStyles: true,
              storeHtml: true,
              storeCss: true,
              urlStore: 'default.aspx?page=<%= Request["page"] %>&moduleID=<%= moduleID %>',
              urlLoad: 'default.aspx?page=<%= Request["page"] %>&moduleID=<%= moduleID %>'

            },
        });
        editor.Panels.addPanel({
          id: 'panel-top',
          el: '.panel__top',
        });
        editor.Panels.addPanel({
          id: 'basic-actions',
          el: '.panel__basic-actions',
          buttons: [
            {
              id: 'visibility',
              //active: true, // active by default
              className: 'btn-toggle-borders',
              label: '<i class="fa fa-object-ungroup" aria-hidden="true"></i>',
              command: 'sw-visibility', // Built-in command
            }, {
              id: 'export',
              className: 'btn-open-export',
              label: '<i class="fa fa-code" aria-hidden="true"></i>',
              command: 'export-template',
              context: 'export-template', // For grouping context of buttons from the same panel
            }, {
              id: 'show-json',
              className: 'btn-show-json',
              label: 'JSON',
              context: 'show-json',
              command(editor) {
                editor.Modal.setTitle('Components JSON')
                  .setContent(`<textarea style="width:100%; height: 250px;">
                    ${JSON.stringify(editor.getComponents())}
                  </textarea>`)
                  .open();
              },
            }
          ],
        });
        editor.Commands.add('show-layers', {
          getRowEl(editor) { return editor.getContainer().closest('.editor-row'); },
          getLayersEl(row) { return row.querySelector('.layers-container') },

          run(editor, sender) {
            const lmEl = this.getLayersEl(this.getRowEl(editor));
            lmEl.style.display = '';
          },
          stop(editor, sender) {
            const lmEl = this.getLayersEl(this.getRowEl(editor));
            lmEl.style.display = 'none';
          },
        });
        editor.Commands.add('show-styles', {
          getRowEl(editor) { return editor.getContainer().closest('.editor-row'); },
          getStyleEl(row) { return row.querySelector('.styles-container') },

          run(editor, sender) {
            const smEl = this.getStyleEl(this.getRowEl(editor));
            smEl.style.display = '';
          },
          stop(editor, sender) {
            const smEl = this.getStyleEl(this.getRowEl(editor));
            smEl.style.display = 'none';
          },
        });
        editor.Commands.add('show-blocks', {
          getTraitsEl(editor) {
            const row = editor.getContainer().closest('.editor-row');
            return row.querySelector('.blocks-container');
          },
          run(editor, sender) {
            this.getTraitsEl(editor).style.display = '';
          },
          stop(editor, sender) {
            this.getTraitsEl(editor).style.display = 'none';
          },
        });
        editor.Commands.add('set-device-desktop', {
          run: editor => editor.setDevice('Desktop')
        });
        editor.Commands.add('set-device-tablet', {
          run: editor => editor.setDevice('Tablet')
        });
        editor.Commands.add('set-device-mobile', {
          run: editor => editor.setDevice('Mobile')
        });
        const am = editor.AssetManager;
        am.addType('flash', {
            isType(value){
                if(typeof value == 'object' && value.type == 'flash') return value;
            }
        });
        am.addType('media', {
            isType(value){
                if(typeof value == 'object' && value.type == 'media') return value;
            }
        });
        am.addType('document', {
            isType(value){
                if(typeof value == 'object' && value.type == 'document') return value;
            }
        });
        am.add([
        <% foreach(string fileURL in ImageArray){ %>
            {
                type: 'image',
                src: "<%= fileURL %>",
            },
        <% } %>
        <% foreach(string fileURL in FlashArray){ %>
            {
                type: 'flash',
                src: "<%= fileURL %>",
            },
        <% } %>
        <% foreach(string fileURL in MediaAray){ %>
            {
                type: 'media',
                src: "<%= fileURL %>",
            },
        <% } %>
        <% foreach(string fileURL in DocumentArray){ %>
            {
                type: 'document',
                src: "<%= fileURL %>",
            },
        <% } %>

        ]);

    </script>

    <button ID="btnSave" class="btn btn-primary" type='button'>Save</button>
    <asp:Button ID="btnFinish" runat="server" CssClass="btn btn-primary" OnClick="btnFinish_Click" Text="Finish"  CausesValidation="false"/>
    <script type="text/javascript">
        $("#btnSave").click(function(){
            editor.store();
        });
    </script>
</asp:Panel>
