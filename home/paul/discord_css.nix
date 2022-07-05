{ theme }:

with theme;

''
  :root {
       --background-primary : #${bg};
       --background-secondary : #${bg};
       --background-secondary-alt : #${bg};
       --background-tertiary : #${bg};
       --background-floating : #${bg};
       --header-primary : #ffffff;
       --interactive-normal : #ffffff;
       --interactive-hover : #ECEFF4;
       --interactive-active : #ECEFF4;
       --interactive-muted : #ffffff;
       --text-normal : #ffffff;
       --text-link : #${c4};
       --text-muted : #ffffff;
       --channeltextarea-background : #${c4};
       --channeltextarea-foreground : #${bg};
       --text-warning : #e06c75;
       --brand-experiment : #434C5E !important;
     }

     //colors for the editor bottom bar thing + buttons
     .markup-eYLPri.editor-H2NA06.slateTextArea-27tjG0.fontSize16Padding-XoMpjI {
	color: var(--channeltextarea-foreground);
	caret-color: var(--channeltextarea-foreground);
     }
     .editor-H2NA06 {
	color: var(--channeltextarea-foreground);
	caret-color: var(--channeltextarea-foreground);
     }
     .buttonWrapper-3YFQGJ {
     	color: #${lbg};
     }
    .attachButtonPlus-3IYelE {
    	transform-origin: 50% 50%;
    	width: 24px;
    	height: 24px;
	fill: var(--background-primary);
    }
    //Server bar thingy
    .scroller-3X7KbA {
    	user-select: none;
    	padding: 20px 0 0 0px;
    	border-radius: 15px;
    	background-color: #${c8};
    	contain: layout size;
    }
    //serveroverview thingy
    .container-1NXEtd {
    	display: flex;
    	-webkit-box-orient: vertical;
    	-webkit-box-direction: normal;
    	flex-direction: column;
    	-webkit-box-align: stretch;
    	align-items: stretch;
    	-webkit-box-pack: start;
    	justify-content: flex-start;
    	-webkit-box-flex: 1;
   	-ms-flex: 1 1 auto;
    	flex: 1 1 auto;
    	min-height: 0;
    	position: relative;
    	background-color: var(--background-primary);
    }

     .container-1D34oG > div {
       background-color : var(--background-primary);
       border-left: 2px solid #${lbg};
       border-top: 2px solid #${lbg};
     }
     .item-3HknzM[aria-label~=Add] {
       background-color : #434C5E !important;
     }
     nav[aria-label="Server"] {
      border-top: 2px solid #${lbg};
      border-right: 2px solid #${lbg};
      border-radius: 15px 15px 15px 15px;
      background-color: #${c4};
      margin-right: 20px;
    }
     .membersWrap-2h-GB4 {
       min-width : 0;
       border-top: 2px solid #${lbg};
       border-left: 2px solid #${lbg};
     }
     .panels-j1Uci_ {
       border-radius: 15px 15px 15px 15px;
       border: 2px solid #${lbg};
       background-color: #${bg};
       margin: 0 10px 10px 10px;
     }
     .root-1gCeng,
     .footer-2gL1pp {
       background-color: var(--background-primary) !important;
            border: 2px solid #${lbg};
     }
''
