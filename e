diff --git a/app/views/earls/_vote_box_js.html.erb b/app/views/earls/_vote_box_js.html.erb
index bbac2b9..88af6b0 100644
--- a/app/views/earls/_vote_box_js.html.erb
+++ b/app/views/earls/_vote_box_js.html.erb
@@ -1,29 +1,43 @@
   var loadedTime = new Date();
 
-  on_idea_submit_button_click = function(event){		
-    var new_idea = $('#facebox .new_idea_field').val();
+  $('.add_idea_button.rounded').click(function() {
+    $('.add_idea_button.rounded').hide();
+    $('#the_add_box').show();  
+    $('#submit_btn').show();  
+  });
+
+//used to have facebox stuff ... i changed that
+
+  on_idea_submit_button_click = function(event){	
+    var new_idea = $('#new_idea_field').val();
     var default_text = $('#default_text').val()
     $('.example_notice').hide();
     
     //if new idea is blank or longer than 140 characters, do not allow it to submit
-    if ((new_idea == 'Add your own idea here...') || (new_idea == '') || new_idea == default_text) {
+    if ((new_idea == 'Add your own idea here...') || (new_idea == '') || new_idea == default_text) {      
         event.returnValue = false;
-	alert('<%=t('vote.submit_idea_default_error') %>');
+      	alert('<%=t('vote.submit_idea_default_error') %>');
         return false;
     }
+
     if (new_idea.length > 140) {
         alert('<%=t('vote.submit_idea_too_long_error') %>');
         event.returnValue = false;
         return false;
     }
-		
+
+    $('#the_add_box').hide();               /* har*/
+    $('#submit_btn').hide();                /* har*/
+    $('.add_idea_button.rounded').show();   /* har*/
+
     $('.tellmearea').html('');
-    $.facebox.close();
+//    $.facebox.close();
     $('.indicator').show();
     $.blockUI({ message: null, fadeIn: 0, fadeOut:  0, overlayCSS:  { 
         backgroundColor: '#000', 
         opacity:         0.0,
         cursor:    null
+
      }});
     
     var question_id = $(this).attr("rel");
@@ -48,11 +62,15 @@
       return false;
     };
 
-    $('.vote_cell').bind('click',function(event){
+  $('.vote_cell').bind('click',function(event){
 
-        var currentTime = new Date();
+  var currentTime = new Date();
 	var time_viewed = currentTime - loadedTime
 
+  //  Added this just in case submit stuff is still there
+  $('#the_add_box').hide();               /* har*/
+  $('#submit_btn').hide();                /* har*/
+  $('.add_idea_button.rounded').show();   /* har*/
 
 	$('.example_notice').hide();
 
@@ -162,29 +180,28 @@
     $('#facebox .close').click($.facebox.close)
     }
 
-   // if popup is for add_idea_submit 
-      $('#facebox .new_idea_submit').bind('click', on_idea_submit_button_click);
-      $('#facebox .new_idea_field').hint();
+    $('.new_idea_submit').bind('click', on_idea_submit_button_click);
 
-    //if popup is for cant_decide_submit
+
+    //  if popup is for cant_decide_submit
     $('.cd_submit_button').bind('click',function(event){
     
        var reason = $('input[name=cant_decide_reason]:checked').val()
 
-        //check that some radio button is selected before closing facebox...
-	if (!reason) {
-	  alert("You must select a reason");
-	  return -1;
-	}
-
-	if(reason == 'user_other'){
-	   user_text = $('#facebox input[name=reason_text]').val()
-	   if(!user_text){
-	      alert("You must include an explanation");
-	      return -1;
-	   }
-	   reason += ":" + user_text;
-	}
+       //check that some radio button is selected before closing facebox...
+	     if (!reason) {
+	     alert("You must select a reason");
+	     return -1;
+	    }
+      
+	    if(reason == 'user_other'){
+	      user_text = $('#facebox input[name=reason_text]').val()
+	      if(!user_text){
+	         alert("You must include an explanation");
+	         return -1;
+	      }
+	      reason += ":" + user_text;
+	  }
 
 	
 	jQuery(document).trigger('close.facebox')
diff --git a/app/views/earls/show.html.haml b/app/views/earls/show.html.haml
index 7e5e8b0..79dbe11 100644
--- a/app/views/earls/show.html.haml
+++ b/app/views/earls/show.html.haml
@@ -4,11 +4,11 @@
 .votebox
   %table.full
     %tr
-      %td{:colspan => 3}= rounded(@question.attributes['name'], 'border')
+      %td.question{:colspan => 3} #{@question.attributes['name']}
+      /above used to be : %td{:colspan => 3, :id => 'question'}= rounded(@question.attributes['name'], 'border')
     %tr.prompt.prompter
       %td.half.idea.left.vote_cell{:rel => @question.id, :id => "left_choice_cell"}
         = rounded(render(:partial => 'questions/idea', :locals => {:data => @left_choice_text, :side => "leftside", :choice_id => @left_choice_id}), 'round-filled')
-      %td
       %td.idea.right.vote_cell{:rel => @question.id, :id => "right_choice_cell"}
         = rounded(render(:partial => 'questions/idea', :locals => {:data => @right_choice_text, :side => "rightside", :choice_id => @right_choice_id}), 'round-filled')
     -if @earl.flag_enabled?
@@ -23,11 +23,7 @@
       %td &nbsp; 
       %td.rounded{:id => I18n.locale == 'fr' ? 'cd_button' : 'cd_button_fr'}
         =link_to(t('vote.cant_decide'), "#cant_decide_options", :id => "cant_decide_btn", :rel => 'facebox[.wider]')
-      %td
-        - if !@earl.flag_enabled?
-          = render :partial => 'vote_idea_count', :locals => {:question => @question}
-        -else
-          &nbsp;
+      %td &nbsp;
   .clear
   %center.add_container
     .add_idea
diff --git a/app/views/items/_form.html.haml b/app/views/items/_form.html.haml
index b859769..e5ae5fd 100644
--- a/app/views/items/_form.html.haml
+++ b/app/views/items/_form.html.haml
@@ -1,21 +1,20 @@
 -form_tag "items_path" do
 
   -ab_test(the_ab_test_name, %w{control make_your_voice_heard help_your_community}, :conversion => 'submitted_idea') do |choice|
-    -link_to("#the_add_box", :rel => 'facebox[.wider]') do
+    -link_to("#the_add_box") do          # har... was "    -link_to("#the_add_box", :rel => 'facebox[.wider]') do"
       .add_idea_button.rounded
-        - unless choice == "control"
-          =t('ab_tests.test_ideasubmit.'+ choice)
-          %br
+        /- unless choice == "control"
+        /  =t('ab_tests.test_ideasubmit.'+ choice)
+        /  %br
         = t('vote.add_your_idea_button')
       
-    - box_text = t('vote.add_your_idea')
+    -box_text = t('vote.add_your_idea')
 
     .add-box#the_add_box{:style => 'display:none'}
       = rounded(text_area_tag('new_idea', '', :title => box_text , :rows => 2, :maxlength => Const::MAX_ITEM_LENGTH, :class => 'new_idea_field', :id => 'new_idea_field'), 'border-thick')
       = hidden_field_tag 'default_text', box_text
       = hidden_field_tag 'question_id', @question_id 
-      %br
-      .fleft
-        = link_to(image_tag("/facebox/closelabel.gif",:title => "close",  :class => "close_image"), {:anchor => ""}, :class => "close")
-      .fright
-        .new_idea_submit.rounded#submit_btn{:rel => @question.id}= t('vote.submit')
+      /*.fleft
+      /*  = link_to(image_tag("/facebox/closelabel.gif",:title => "close",  :class => "close_image"), {:anchor => ""}, :class => "close")
+      /*.fright
+    .new_idea_submit.rounded#submit_btn{:rel => @question.id, :style => 'display:none'}= t('vote.submit')
diff --git a/app/views/items/_list.html.haml b/app/views/items/_list.html.haml
index 39b19cf..7b5b1c2 100644
--- a/app/views/items/_list.html.haml
+++ b/app/views/items/_list.html.haml
@@ -11,4 +11,4 @@
       %td= status(active == '1')
       %td=# activate_link(id, active.to_i, @question_internal.id)
 %hr
-%h3= link_to t('items.create_new_items'), "new_admin_item_path(:question_id => @id)"
\ No newline at end of file
+%h3= link_to t('items.create_new_items'), "new_admin_item_path(:question_id => @id)"
diff --git a/app/views/shared/_footer.html.haml b/app/views/shared/_footer.html.haml
index 2e81082..4d8df5c 100644
--- a/app/views/shared/_footer.html.haml
+++ b/app/views/shared/_footer.html.haml
@@ -1,30 +1,32 @@
-.footer
-  .triple-left
-    = link_to(image_tag('logo-google.jpg', :id => 'logo-google'), 'http://research.google.com/university/relations/research_awards.html')
-    = link_to(image_tag('logo-citp.jpg', :id => 'logo-citp'), 'http://citp.princeton.edu/')
-    = link_to(image_tag('logo-princeton.jpg', :id => 'logo-princeton'), 'http://www.princeton.edu/')
-    %p= t('footer.support')
-  .triple-center
-    = link_to(image_tag('logo-open.jpg', :id => 'logo-open'), 'http://github.com/allourideas')
-    %p= t('footer.open_source')
-  .triple-right
-    = link_to(image_tag('logo-check.jpg', :id => 'logo-check'), 'http://www.allourideas.org')
-    -if signed_in?
-      %p
-        = "#{t('footer.logged_in')} as #{current_user.email}"
-        %br
-        = link_to t('user.logout'), '/sign_out'
-        %br
-        = link_to t('user.control_panel'), admin_path
-    -elsif signed_in?
-      %p
-        = "#{t('footer.logged_in')} at this computer but not yet registered"
-        %br
-        =# #{link_to(t('footer.my_questions'), users_path)} &nbsp;//&nbsp; #{link_to(t('user.logout'), sign_out_path)}
-    -else
-      %p
-        = link_to t('user.login'), sign_in_path
-        %br
-        = link_to t('nav.make_your_own'), new_question_path
-        %br
-        = link_to t('nav.about'), about_path
+/
+  .footer
+    .triple-left
+      = link_to(image_tag('logo-google.jpg', :id => 'logo-google'), 'http://research.google.com/university/relations/research_awards.html')
+      = link_to(image_tag('logo-citp.jpg', :id => 'logo-citp'), 'http://citp.princeton.edu/')
+      = link_to(image_tag('logo-princeton.jpg', :id => 'logo-princeton'), 'http://www.princeton.edu/')
+      %p= t('footer.support')
+    .triple-center
+      = link_to(image_tag('logo-open.jpg', :id => 'logo-open'), 'http://github.com/allourideas')
+      %p= t('footer.open_source')
+    .triple-right
+      = link_to(image_tag('logo-check.jpg', :id => 'logo-check'), 'http://www.allourideas.org')
+      -if signed_in?
+        %p
+          = "#{t('footer.logged_in')} as #{current_user.email}"
+          %br
+          = link_to t('user.logout'), '/sign_out'
+          %br
+          = link_to t('user.control_panel'), admin_path
+      -elsif signed_in?
+        %p
+          = "#{t('footer.logged_in')} at this computer but not yet registered"
+          %br
+          =# #{link_to(t('footer.my_questions'), users_path)} &nbsp;//&nbsp; #{link_to(t('user.logout'), sign_out_path)}
+      -else
+        %p
+          = link_to t('user.login'), sign_in_path
+          %br
+          = link_to t('nav.make_your_own'), new_question_path
+          %br
+          = link_to t('nav.about'), about_path
+/*yeah i tabbed all this stuff above over... block comment
diff --git a/app/views/shared/_header.html.haml b/app/views/shared/_header.html.haml
index 59b969a..cbe030d 100644
--- a/app/views/shared/_header.html.haml
+++ b/app/views/shared/_header.html.haml
@@ -1,10 +1,13 @@
-.header
-  .fleft.clear{:style => "clear:right;"}
-    = link_to(image_tag("logo#{'-small' if (@earl && !@earl.logo_file_name.nil?)}.jpg"), root_path, :class => 'logo')
-  -if controller.controller_name == 'home' || (controller.controller_name == 'questions' && controller.action_name == 'new')
-    .fright
-      %ul
-        %li= link_to(t('nav.home'), root_path, class_for_nav(params, 'index'))
-        %li= link_to(t('nav.create'), new_question_path, class_for_nav(params, 'new', 'questions'))
-        %li= link_to(t('nav.about'), about_path, class_for_nav(params, 'about'))
-  .clear
+/
+  .header
+    .fleft.clear{:style => "clear:right;"}
+      = link_to(image_tag("logo#{'-small' if (@earl && !@earl.logo_file_name.nil?)}.jpg"), root_path, :class => 'logo')
+    -if controller.controller_name == 'home' || (controller.controller_name == 'questions' && controller.action_name == 'new')
+      .fright
+        %ul
+          %li= link_to(t('nav.home'), root_path, class_for_nav(params, 'index'))
+          %li= link_to(t('nav.create'), new_question_path, class_for_nav(params, 'new', 'questions'))
+          %li= link_to(t('nav.about'), about_path, class_for_nav(params, 'about'))
+    .clear
+/*yeah i tabbed all this stuff above over... block comment
+
diff --git a/config/database.yml b/config/database.yml
index daf5330..dc45980 100644
--- a/config/database.yml
+++ b/config/database.yml
@@ -6,6 +6,9 @@ development: &default
   database: allourideas_development
   pool: 5
   timeout: 5000
+  host: localhost
+  user: root
+  password: 1briant
 
 #development: &default
 #  adapter: sqlite3
diff --git a/config/environments/development.rb b/config/environments/development.rb
index 527b880..2f656e8 100644
--- a/config/environments/development.rb
+++ b/config/environments/development.rb
@@ -22,7 +22,7 @@ HOST = 'localhost:3001'
 #API_HOST = 'http://allourideas.com'
 API_HOST = "http://localhost:3000"
 
-PAIRWISE_USERNAME = "pairwisetest@dkapadia.com"
+PAIRWISE_USERNAME = "testing@dkapadia.com"
 PAIRWISE_PASSWORD = "wheatthins"
 
 IP_ADDR_HASH_SALT = '2039d9ds9ufsdioh2394230' #prevent dictionary attacks on stored ip address hashes
diff --git a/public/stylesheets/sass/screen.sass b/public/stylesheets/sass/screen.sass
index bdc302a..bd1f48f 100644
--- a/public/stylesheets/sass/screen.sass
+++ b/public/stylesheets/sass/screen.sass
@@ -1,329 +1,579 @@
+/*  This is an updated screeen.css converted into sass and messed with */
+
 *
-  :margin 0 auto
-  :padding 0
+  margin: 0 auto
+  padding: 0
+
 a
-  :text-decoration none
-  :color #54afe2
-  img
-    :border none
-  &:hover
-    :border-bottom 1px dotted #54afe2
-  &:active
-    :border none
+  text-decoration: none
+  color: #54afe2
+  img, &:active
+    border: none
+
+/*  a:hover {
+/*  border-bottom: 1px dotted #54afe2; }
+
 .fleft
-  :float left
+  float: left
+
 .fright
-  :float right
+  float: right
+
 .center
-  :text-align center
+  text-align: center
+
 .clear
-  :clear both
-.grey
-  :color #919191
-label
-  :color #919191
+  clear: both
+
+.grey, label
+  color: #919191
+
+$scaleFactor = .5
+
+/*Messing with har*/
 body
-  :font-family Arial, Helvetica, sans-serif
-  :font-size 12px
-  :width 850px
-  :color #919191
-  :line-height 16pt
+  font-family: Arial, Helvetica, sans-serif
+  font-size: 12px
+  width: 850px * $scaleFactor
+  color: #919191
+  line-height: 16pt
+
 h1, h2, h3, h4, h5, h6, .large-text
-  :color #797979
+  color: #797979
+
 p, h1, h2, h3, h4, h5, h6, table, .large-text
-  :padding 5px 0px
+  padding: 5px 0px
+
 h1
-  :font-size 20px
+  font-size: 20px
+
 h2, .large-text
-  :font-size 16px
-  :font-weight normal
+  font-size: 16px
+  font-weight: normal
+
 h3
-  :font-size 14px
-  :font-weight normal
+  font-size: 14px
+  font-weight: normal
+
 h4
-  :font-size 12px
-  :font-weight normal
-ul
-  li
-    :margin-left 20px
-.full 
-  :width 100%
+  font-size: 12px
+  font-weight: normal
+
+ul li
+  margin-left: 20px
+
+.full
+  width: 100%
+
 .half
-  :width 50%
+  width: 50%
+
 .ninety
-  :width 90%
+  width: 90%
+
 input.text
-  :border 1px solid #919191
-  :padding 3px 3px 2px
+  border: 1px solid #919191
+  padding: 3px 3px 2px
+
 .padding
-  :margin 5px 0px
+  margin: 5px 0px
+
 table
-  :text-align left
-  :border-collapse collapse
+  text-align: left
+  border-collapse: collapse
   td, th
-    :padding 5px
+    padding: 5px
   .title
-    :width 545px
+    width: 545px
   .row0
-    :background-color #3198c1
-    :color white
+    background-color: #3198c1
+    color: white
     th.score
-      :width 95px
+      width: 95px
   .row1
-    :background-color #fafafa
+    background-color: #fafafa
   .row2
-    :background-color #fefefe
+    background-color: #fefefe
   .thin td
-    :padding 2px 5px
-    :height 2px
+    padding: 2px 5px
+    height: 2px
   .votes
-    :min-width 80px
+    min-width: 90px
   &.recent-winners td
-    :text-align center
-  &.item
-    td:last-child
-      :font-weight bold
+    text-align: center
+  &.item td:last-child
+    font-weight: bold
   &.left
-    :margin 0
+    margin: 0
   &.signup td
-    :max-width 400px
+    max-width: 400px
+
 .create-question
   h2
-    :padding-bottom 0px
+    padding-bottom: 0px
   p
-    :padding 15px 25px
-    :font-size 14px
+    padding: 15px 25px
+    font-size: 14px
     &.ideas
-      :padding-bottom 10px
-      :padding-right 400px
+      padding-bottom: 10px
+      padding-right: 400px
   .fieldWithErrors
-    :padding 2px 0 3px
-    :border 1px solid #ff6464
+    padding: 2px 0 3px
+    border: 1px solid #ff6464
+
 .errorExplanation
-  :color #FFF
-  :background #ff6464
-  :padding 8px 5px
-  :border 1px solid #000
+  color: #FFF
+  background: #ff6464
+  padding: 8px 5px
+  border: 1px solid #000
   h2
-    :color #FFF
+    color: #FFF
   ul li
-    :margin-left 40px
+    margin-left: 40px
+
 .header
-  :padding 30px 5px 15px 5px
-  :border-bottom 1px solid #f4f5f6
+  padding: 30px 5px 15px 5px
+  border-bottom: 1px solid #f4f5f6
   .fright
-    :padding-top 18px
+    padding-top: 18px
     ul li
-      :list-style-type none
-      :float left
-      :font-size 14px
-      :text-transform uppercase
-      :margin 0
+      list-style-type: none
+      float: left
+      font-size: 14px
+      text-transform: uppercase
+      margin: 0
       a
-        :padding 5px 20px
-        :color #919191
+        padding: 5px 20px
+        color: #54afe2
         &:hover
-          :color #54afe2
-          :border-top 1px dotted #54afe2
-          :border-bottom 1px dotted #54afe2
+          border-top: 1px dotted #54afe2
+          border-bottom: 1px dotted #54afe2
         &.down
-          :color #54afe2
+          color: #919191
   a.logo:hover
-    :border none
+    border: none
+
 .bread-crumb
-  :color #54afe2
+  color: #54afe2
+
 .body
-  :margin 1px 0px
-  :padding 20px 5px 30px
-  :border-top 1px solid #d8dbdc
-  :border-bottom 1px solid #d8dbdc
+  margin: 1px 0px
+/*  padding: 20px 5px 30px           /*har*/
+  border-top: 1px solid #d8dbdc
+  border-bottom: 1px solid #d8dbdc
   .center img
-    :padding 0px 0px 30px 0px
-  .triple-left, #body .triple-center, #body .triple-right
-    :min-height 150px
+    padding: 0px 0px 30px 0px
+  .triple-left
+    min-height: 150px
+  #body
+    .triple-center, .triple-right
+      min-height: 150px
 
 .triple-left, .triple-center, .triple-right, .double-left
-  :float left
+  float: left
+
 .noborder
-  :border none
+  border: none
+
 .image-example
-  :border 2px solid #eeeeee
-  :width 250px
-  :margin 0px 0px 10px
+  border: 2px solid #eeeeee
+  width: 250px
+  margin: 0px 0px 10px
+
 .button
-  :border 1px solid #3198c1
-  :width 125px
-  :padding 2px 0px
-  :background-color #54afe2
-  :text-align center
-  :float left
+  border: 1px solid #3198c1
+  width: 125px
+  padding: 2px 0px
+  background-color: #54afe2
+  text-align: center
+  float: left
+
 .button-link
-  :color white
+  color: white
+
 .button:hover
-  :border 1px solid #3198c1
+  border: 1px solid #3198c1
+
 .triple-left
-  :border-right 1px dotted #d8dbdc
-  :padding 0px 15px 2px 0px
-  :width 264px
+  border-right: 1px dotted #d8dbdc
+  padding: 0px 15px 2px 0px
+  width: 264px
+
 .triple-center
-  :border-right 1px dotted #d8dbdc
-  :padding 0px 15px 2px 15px
-  :width 249px
+  border-right: 1px dotted #d8dbdc
+  padding: 0px 15px 2px 15px
+  width: 249px
+
 .triple-right
-  :padding 0px 0px 2px 15px
-  :width 265px
+  padding: 0px 0px 2px 15px
+  width: 265px
+
 .double-left
-  :padding 0px 15px 2px 0px
-  :width 545px
-.votebox, .vote-nav
-  :width 90%
-.vote-nav
-  :font-size 14px
-  :padding-bottom 2px
+  padding: 0px 15px 2px 0px
+  width: 545px
+
+$fontScaleFactor: .80
+
 .votebox
-  table
-    :text-align center
-    td
-      :padding 0 0 5px
-    td .borderfg
-      :padding 30px 20px
-      :font-size 22px
-      :color #555
+  width: 90%
+
+.vote-nav
+  width: 90%
+  font-size: 16px * $fontScaleFactor
+  padding-bottom: 2px
+
+/* Messing with here */
+.votebox table
+  text-align: center
+  td
+    padding: 0 0 5px
+    .borderfg               /*doesn't do anything afaik*/
+      padding: 30px 20px
+      font-size: 22px * $fontScaleFactor
+      color: #555
+    &.question                     /* har*/
+      font-size: 22px * $fontScaleFactor
+      color: #555
+      border: 20px
+      border-color: dsklamdf
+    &.idea
+      cursor: pointer
+    &.left                
+      padding: 0 2.5px 0 0  /* har*/
+    &.right
+      padding: 0 0 0 2.5px    /* har*/
+    .round-filledfg
+      font-size: 16px * $fontScaleFactor
+      padding: 0 0px        /* har... not sure what this line is good for*/
+      a
+        color: #FFF
+        border: none
+        &:hover
+          color: #FFF
+          border: none
+    table td
+      height: 95px * $scaleFactor 
+  &.vote-footer                       /*can't decide button*/
+    margin-top: 10px * $scaleFactor   /*har*/
     td
-      &.idea
-        :cursor pointer
-      &.left
-        :padding 0 5px 0 0
-      &.right
-        :padding 0 0 0 5px
-      .round-filledfg
-        :font-size 16px
-        :padding 0 5px
-        a, a:hover
-          :color #FFF
-          :border none
-      table td
-        :height 95px
-    &.vote-footer
-      :width 100%
-      td
-        :padding 5px 0 10px
-        :width 33%
-        &:first-child
-          :text-align left
-          :width 33.5%
-        &:last-child
-          :text-align right
+      padding: 5px * $scaleFactor 0 5px * $scaleFactor
+      width: 33%
+      &:first-child
+        text-align: left
+        width: 33.5%
+      &:last-child
+        text-align: right
+
 .skip
-  :margin 10px 0
+  margin: 10px 0
+
 .footer
-  :padding 10px 5px
-  :border-top 1px solid #f4f5f6
+  padding: 10px 5px
+  border-top: 1px solid #f4f5f6    
   .triple-left, .triple-center, .triple-right
-    :font-size 10px
-    :line-height 12pt
-    :color #AAA
+    font-size: 10px
+    line-height: 12pt
+    color: #AAA
   img
-    :padding-right 10px
-    :float left
+    padding-right: 10px
+    float: left
   p
-    :float right
-    :padding 0
+    float: right
+    padding: 0
   .triple-left p
-    :width 187px
+    width: 153px
   .triple-center p
-    :width 205px
+    width: 205px
   .triple-right p
-    :width 220px
+    width: 220px
+
 div.bar-chart
-  :border 1px solid #ccc
-  :width 250px
-  :margin 2px 5px 2px 0
-  :padding 1px
-  :float left
-  :background white
-div.bar-chart > div
-  :background-color #797979
-  :height 12px
-  :margin 0
+  border: 1px solid #ccc
+  width: 250px
+  margin: 2px 5px 2px 0
+  padding: 1px
+  float: left
+  background: white
+  > div
+    background-color: #797979
+    height: 12px
+    margin: 0
+
 hr
-  :border none
-  :border-bottom 1px dotted #BBB
-  :margin 0 0 15px 0
+  border: none
+  border-bottom: 1px dotted #BBB
+  margin: 0 0 15px 0
+
 .add-box
-  :width 325px
+  width: 850px * .9 * $scaleFactor     /*har*/
+  padding: 2.5px
   textarea
-    :padding 2px 0
-    :border none
-    :width 300px
+    padding: 1px 0                    /*har*/
+    border: none
+    width: 825px * .9 * $scaleFactor     /*har*/
+
 input, textarea
-  :font-size 13px
-  :color #919191
-  :font-family Arial, Helvetica, sans-serif
+  font-size: 13px
+  color: #919191
+  font-family: Arial, Helvetica, sans-serif
+
 .form-btn
-  :color #000
+  color: #000
+
 .error, .notice, .vote-notice
-  :color #FFF
-  :background-color #ff6464
-  :margin -10px 10em 25px
-  :text-align center
-  :font-size 13px
+  color: #FFF
+  background-color: #ff6464
+  margin: -10px 10em 25px
+  text-align: center
+  font-size: 13px
+
 .notice
-  :background-color #FFC
-  :border 1px solid #797979
-  :color #797979
-  :text-align left
-  :padding 5px 10px
-  :margin 0 40px 25px
+  background-color: #FFC
+  border: 1px solid #797979
+  color: #797979
+  text-align: left
+  padding: 5px 10px
+  margin: 0 40px 25px
   span.close
-    :display block
-    :text-align right
+    display: block
+    text-align: right
     &:hover
-      :border none
+      border: none
+
 .vote-notice
-  :background-color #0B0
-// border
-.border *, .border-thick *, .round-filled *
-  :font-size 0.01px
-  :line-height 0.01px
-  :display block
-  :height 1px
-  :overflow hidden
-  :padding 0px
-.border-top, .border-bottom, .border2, .round-filled-top, .round-filled-bottom
-  :padding-left 1px
-  :padding-right 1px
+  background-color: #0B0
+
+.border *, .border-thick *, .round-filled *, .round-filled-grey *
+  font-size: 0.01px
+  line-height: 0.01px
+  display: block
+  height: 1px
+  overflow: hidden
+  padding: 0px
+
+.border-top, .border-bottom, .border2, .round-filled-top, .round-filled-bottom, .round-filled-grey-top, round-filled-grey-top
+  padding-left: 1px
+  padding-right: 1px
+
 .border-top, .border-bottom
-  :margin-left 3px
-  :margin-right 3px
+  margin-left: 3px
+  margin-right: 3px
+
 .border-top
-  :border-bottom 1px solid #e9e9e9
+  border-bottom: 1px solid #e9e9e9
+
 .border-bottom
-  :border-top 1px solid #e9e9e9
+  border-top: 1px solid #e9e9e9
+
 .border2, .border3, .border4, .border5, .borderfg
-  :border-left 1px solid #e9e9e9
-  :border-right 1px solid #e9e9e9
+  border-left: 1px solid #e9e9e9
+  border-right: 1px solid #e9e9e9
+
 .border2, .border3
-  :margin-left 1px
-  :margin-right 1px
+  margin-left: 1px
+  margin-right: 1px
+
 .border-thick-top
-  :border-bottom 2px solid #e9e9e9
+  border-bottom: 2px solid #e9e9e9
+
 .border-thick-bottom
-  :border-top 2px solid #e9e9e9
+  border-top: 2px solid #e9e9e9
+
 .border-thick2, .border-thick3, .border-thick4, .border-thick5, .border-thickfg
-  :border-left 2px solid #e9e9e9
-  :border-right 2px solid #e9e9e9
-// rounded corners
+  border-left: 2px solid #e9e9e9
+  border-right: 2px solid #e9e9e9
+
 .round-filled-top, .round-filled-bottom
-  :margin-left 3px
-  :margin-right 3px
-  :border-left 1px solid #3198c1
-  :border-right 1px solid #3198c1
-  :background #3198c1
+  margin-left: 3px
+  margin-right: 3px
+  border-left: 1px solid #3198c1
+  border-right: 1px solid #3198c1
+  background: #3198c1
+
+.round-filled-grey-top, .round-filled-grey-bottom
+  margin-left: 3px
+  margin-right: 3px
+  border-left: 1px solid #cccccc
+  border-right: 1px solid #cccccc
+  background: #cccccc
+
+.round-filled-grey2, .round-filled-grey3, .round-filled-grey4, .round-filled-grey5, .round-filled-greyfg
+  border-left: 1px solid #cccccc
+  border-right: 1px solid #cccccc
+  background: #cccccc
+  color: #686868
+
 .round-filled2, .round-filled3, .round-filled4, .round-filled5, .round-filledfg
-  :border-left 1px solid #3198c1
-  :border-right 1px solid #3198c1
-  :background #3198c1
-.round-filled2, .round-filled3
-  :margin-left 1px
-  :margin-right 1px
\ No newline at end of file
+  border-left: 1px solid #3198c1
+  border-right: 1px solid #3198c1
+  background: #3198c1
+
+.round-filled2, .round-filled3, .round-filled-grey2, .round-filled-grey3
+  margin-left: 1px
+  margin-right: 1px
+
+.toggle_question_status, .toggle_choice_status, .toggle_autoactivate_status
+  text-align: center
+  color: #ffffff
+  cursor: pointer
+  line-height: 14px
+
+div.form_field
+  position: relative
+  float: left
+
+label.over-apply
+  color: #ccc
+  position: absolute
+  top: 0px
+  left: 5px
+
+table.tablesorter
+  font-family: arial
+  margin: 10px 0pt 15px
+  font-size: 8pt
+  width: 100%
+  text-align: left
+  thead tr th, tfoot tr th
+    border: 1px solid #FFF
+    font-size: 8pt
+    padding: 4px 20px 4px 4px
+  thead tr .header
+    background-image: url('/images/bg.gif')
+    background-repeat: no-repeat
+    background-position: center right
+    cursor: pointer
+  tbody
+    td
+      color: #3D3D3D
+      padding: 4px
+      vertical-align: top
+    tr
+      &.odd td
+        background-color: #fafafa
+      &.even td
+        background-color: #fefefe
+  thead tr
+    .headerSortUp
+      background-image: url('/images/asc.gif')
+    .headerSortDown
+      background-image: url('/images/desc.gif')
+    .headerOver
+      background-color: #8dbdd8
+
+.twenty_pixel_font
+  font-size: 20px
+
+.sixteen_pixel_font
+  font-size: 16px
+
+.twelve_pixel_font
+  font-size: 12px
+
+.active
+  color: #000000
+
+.firsttime
+  position: fixed
+  top: 0
+  left: 0
+  width: 100%
+  z-index: 100
+  background: #4dbae6
+  color: #185b75
+  font-size: 15px
+  font-weight: bold
+  text-align: center
+  border-bottom: 1px solid #1f7293
+  padding: 4px
+  margin-bottom: 8px
+  display: none
+
+#cant_decide_options
+  width: 500px
+
+.wider
+  color: #000000
+  td
+    padding: 5px !important
+    &.no_bottom_padding
+      padding-bottom: 0px !important
+    &.no_top_padding
+      padding-top: 0px !important
+      vertical-align: top
+  h2
+    font-weight: bold
+    color: #3198c1
+
+#cd_button
+  background: #C5C5C5
+  width: 17%
+  a
+    color: #FFFFFF
+    display: block
+    font-size: 16px
+  &:hover
+    background-color: #B1B1B1
+
+/* Messing with here... But nothing is changed right now */
+#cd_button_fr
+  background: #C5C5C5
+  width: 21%
+  a
+    color: #FFFFFF
+    display: block
+    font-size: 16px * $fontScaleFactor
+  &:hover
+    background-color: #B1B1B1
+
+.cd_submit_button
+  padding: 5px 10px 5px 10px
+  background: #3198C1
+  cursor: pointer
+  color: #FFFFFF
+  &:hover
+    background-color: #2B88AD
+
+/* Messing with here...*/
+.add_idea
+  margin: 10px * $scaleFactor 0px 0px 0px
+  .add_idea_button
+    padding: 5px * $scaleFactor 10px * $scaleFactor 5px * $scaleFactor 10px * $scaleFactor    /*har*/
+    width: 265px * $scaleFactor     /*har*/
+    height: 3em * $scaleFactor      /*har*/
+    display: table-cell
+    vertical-align: middle
+    color: #FFFFFF
+    font-size: 16px * $fontScaleFactor  /*har*/
+    cursor: pointer
+    background: #01bb00
+    a
+      color: #FFFFFF
+    &:hover
+      background: #228b53
+
+#facebox
+  cursor: move
+
+.add_container
+  height: 9em
+
+.new_idea_submit
+  padding: 5px * $scaleFactor 10px * $scaleFactor 5px * $scaleFactor 10px * $scaleFactor    /*har*/
+  background: #01bb00
+  cursor: pointer
+  color: #FFFFFF
+  width: 265px * $scaleFactor     /*har*/
+  &:hover
+    background-color: #228b53
+
+.flag_submit_button
+  padding: 5px 10px 5px 10px
+  background: #3198C1
+  cursor: pointer
+  color: #FFFFFF
+  &:hover
+    background-color: #2B88AD
+
+.no_bottom_padding
+  padding-bottom: 0px !important
diff --git a/public/stylesheets/screen.css b/public/stylesheets/screen.css
index 9481e91..9c38178 100644
--- a/public/stylesheets/screen.css
+++ b/public/stylesheets/screen.css
@@ -1,3 +1,4 @@
+/*  This is an updated screeen.css converted into sass and messed with */
 * {
   margin: 0 auto;
   padding: 0; }
@@ -5,13 +6,11 @@
 a {
   text-decoration: none;
   color: #54afe2; }
-  a img {
-    border: none; }
-/*  a:hover {
-    border-bottom: 1px dotted #54afe2; }*/
-  a:active {
+  a img, a:active {
     border: none; }
 
+/*  a:hover { */
+/*  border-bottom: 1px dotted #54afe2; } */
 .fleft {
   float: left; }
 
@@ -24,16 +23,14 @@ a {
 .clear {
   clear: both; }
 
-.grey {
-  color: #919191; }
-
-label {
+.grey, label {
   color: #919191; }
 
+/*Messing with har */
 body {
   font-family: Arial, Helvetica, sans-serif;
   font-size: 12px;
-  width: 850px;
+  width: 425px;
   color: #919191;
   line-height: 16pt; }
 
@@ -120,12 +117,12 @@ table {
   border: 1px solid #ff6464; }
 
 .errorExplanation {
-  color: #FFF;
+  color: white;
   background: #ff6464;
   padding: 8px 5px;
-  border: 1px solid #000; }
+  border: 1px solid black; }
   .errorExplanation h2 {
-    color: #FFF; }
+    color: white; }
   .errorExplanation ul li {
     margin-left: 40px; }
 
@@ -142,7 +139,7 @@ table {
       margin: 0; }
       .header .fright ul li a {
         padding: 5px 20px;
-        color: #54afe2;}
+        color: #54afe2; }
         .header .fright ul li a:hover {
           border-top: 1px dotted #54afe2;
           border-bottom: 1px dotted #54afe2; }
@@ -155,15 +152,18 @@ table {
   color: #54afe2; }
 
 .body {
-  margin: 1px 0px;
-  padding: 20px 5px 30px;
-  border-top: 1px solid #d8dbdc;
-  border-bottom: 1px solid #d8dbdc; }
-  .body .center img {
-    padding: 0px 0px 30px 0px; }
-  .body .triple-left, .body #body .triple-center, .body #body .triple-right {
-    min-height: 150px; }
-
+  margin: 1px 0px; }
+
+/*  padding: 20px 5px 30px           /*har*/
+ * border-top: 1px solid #d8dbdc
+ * border-bottom: 1px solid #d8dbdc
+ * .center img
+ *   padding: 0px 0px 30px 0px
+ * .triple-left
+ *   min-height: 150px
+ * #body
+ *   .triple-center, .triple-right
+ *     min-height: 150px */
 .triple-left, .triple-center, .triple-right, .double-left {
   float: left; }
 
@@ -207,41 +207,49 @@ table {
   padding: 0px 15px 2px 0px;
   width: 545px; }
 
-.votebox, .vote-nav {
+.votebox {
   width: 90%; }
 
 .vote-nav {
-  font-size: 16px;
+  width: 90%;
+  font-size: 12.8px;
   padding-bottom: 2px; }
 
+/* Messing with here */
 .votebox table {
   text-align: center; }
   .votebox table td {
     padding: 0 0 5px; }
-  .votebox table td .borderfg {
-    padding: 30px 20px;
-    font-size: 22px;
-    color: #555; }
-  .votebox table td.idea {
-    cursor: pointer; }
-  .votebox table td.left {
-    padding: 0 5px 0 0; }
-  .votebox table td.right {
-    padding: 0 0 0 5px; }
-  .votebox table td .round-filledfg {
-    font-size: 16px;
-    padding: 0 5px; }
-    .votebox table td .round-filledfg a, .votebox table td .round-filledfg a:hover {
-      color: #FFF;
-      border: none; }
-  .votebox table td table td {
-    height: 95px; }
+    .votebox table td .borderfg {
+      padding: 30px 20px;
+      font-size: 17.6px;
+      color: #555555; }
+    .votebox table td.question {
+      font-size: 17.6px;
+      color: #555555;
+      border: 20px;
+      border-color: dsklamdf; }
+    .votebox table td.idea {
+      cursor: pointer; }
+    .votebox table td.left {
+      padding: 0 2.5px 0 0; }
+    .votebox table td.right {
+      padding: 0 0 0 2.5px; }
+    .votebox table td .round-filledfg {
+      font-size: 12.8px;
+      padding: 0 0px; }
+      .votebox table td .round-filledfg a {
+        color: white;
+        border: none; }
+        .votebox table td .round-filledfg a:hover {
+          color: white;
+          border: none; }
+    .votebox table td table td {
+      height: 47.5px; }
   .votebox table.vote-footer {
-    width: 100%; 
-    margin-top: 10px;
-    }
+    margin-top: 5px; }
     .votebox table.vote-footer td {
-      padding: 5px 0 5px;
+      padding: 2.5px 0 2.5px;
       width: 33%; }
       .votebox table.vote-footer td:first-child {
         text-align: left;
@@ -258,7 +266,7 @@ table {
   .footer .triple-left, .footer .triple-center, .footer .triple-right {
     font-size: 10px;
     line-height: 12pt;
-    color: #AAA; }
+    color: #aaaaaa; }
   .footer img {
     padding-right: 10px;
     float: left; }
@@ -273,30 +281,29 @@ table {
     width: 220px; }
 
 div.bar-chart {
-  border: 1px solid #ccc;
+  border: 1px solid #cccccc;
   width: 250px;
   margin: 2px 5px 2px 0;
   padding: 1px;
   float: left;
   background: white; }
-
-div.bar-chart > div {
-  background-color: #797979;
-  height: 12px;
-  margin: 0; }
+  div.bar-chart > div {
+    background-color: #797979;
+    height: 12px;
+    margin: 0; }
 
 hr {
   border: none;
-  border-bottom: 1px dotted #BBB;
+  border-bottom: 1px dotted #bbbbbb;
   margin: 0 0 15px 0; }
 
 .add-box {
-  width: 425px; 
-  }
+  width: 382.5px;
+  padding: 2.5px; }
   .add-box textarea {
-    padding: 2px 0;
+    padding: 1px 0;
     border: none;
-    width: 400px; }
+    width: 371.25px; }
 
 input, textarea {
   font-size: 13px;
@@ -304,17 +311,17 @@ input, textarea {
   font-family: Arial, Helvetica, sans-serif; }
 
 .form-btn {
-  color: #000; }
+  color: black; }
 
 .error, .notice, .vote-notice {
-  color: #FFF;
+  color: white;
   background-color: #ff6464;
   margin: -10px 10em 25px;
   text-align: center;
   font-size: 13px; }
 
 .notice {
-  background-color: #FFC;
+  background-color: #ffffcc;
   border: 1px solid #797979;
   color: #797979;
   text-align: left;
@@ -327,7 +334,7 @@ input, textarea {
       border: none; }
 
 .vote-notice {
-  background-color: #0B0; }
+  background-color: #00bb00; }
 
 .border *, .border-thick *, .round-filled *, .round-filled-grey * {
   font-size: 0.01px;
@@ -337,7 +344,7 @@ input, textarea {
   overflow: hidden;
   padding: 0px; }
 
-.border-top, .border-bottom, .border2, .round-filled-top, .round-filled-bottom, .round-filled-grey-top,round-filled-grey-top {
+.border-top, .border-bottom, .border2, .round-filled-top, .round-filled-bottom, .round-filled-grey-top, round-filled-grey-top {
   padding-left: 1px;
   padding-right: 1px; }
 
@@ -375,20 +382,19 @@ input, textarea {
   border-left: 1px solid #3198c1;
   border-right: 1px solid #3198c1;
   background: #3198c1; }
-  
+
 .round-filled-grey-top, .round-filled-grey-bottom {
   margin-left: 3px;
   margin-right: 3px;
   border-left: 1px solid #cccccc;
   border-right: 1px solid #cccccc;
   background: #cccccc; }
-  
+
 .round-filled-grey2, .round-filled-grey3, .round-filled-grey4, .round-filled-grey5, .round-filled-greyfg {
   border-left: 1px solid #cccccc;
   border-right: 1px solid #cccccc;
-  background: #cccccc; 
-  color: #686868;
-  }
+  background: #cccccc;
+  color: #686868; }
 
 .round-filled2, .round-filled3, .round-filled4, .round-filled5, .round-filledfg {
   border-left: 1px solid #3198c1;
@@ -401,180 +407,163 @@ input, textarea {
 
 .toggle_question_status, .toggle_choice_status, .toggle_autoactivate_status {
   text-align: center;
-  color: #ffffff;
+  color: white;
   cursor: pointer;
-  line-height: 14px;
-}
+  line-height: 14px; }
 
-div.form_field { position: relative; float: left; }
-label.over-apply { color: #ccc; position: absolute; top: 0px; left: 5px;}
+div.form_field {
+  position: relative;
+  float: left; }
+
+label.over-apply {
+  color: #cccccc;
+  position: absolute;
+  top: 0px;
+  left: 5px; }
 
 table.tablesorter {
-	font-family:arial;
-	margin:10px 0pt 15px;
-	font-size: 8pt;
-	width: 100%;
-	text-align: left;
-}
-table.tablesorter thead tr th, table.tablesorter tfoot tr th {
-	border: 1px solid #FFF;
-	font-size: 8pt;
-	padding: 4px 20px 4px 4px;
-}
-table.tablesorter thead tr .header {
-	background-image: url('/images/bg.gif');
-	background-repeat: no-repeat;
-	background-position: center right;
-	cursor: pointer;
-}
-table.tablesorter tbody td {
-	color: #3D3D3D;
-	padding: 4px;
-	vertical-align: top;
-}
-table.tablesorter tbody tr.odd td {
-    background-color: #fafafa; 
-}
-table.tablesorter tbody tr.even td {
-    background-color: #fefefe; 
-}
-table.tablesorter thead tr .headerSortUp {
-	background-image: url('/images/asc.gif');
-}
-table.tablesorter thead tr .headerSortDown {
-	background-image: url('/images/desc.gif');
-}
-table.tablesorter thead tr .headerOver{
-background-color: #8dbdd8;
-}
-.twenty_pixel_font{
-	font-size: 20px;
-}
+  font-family: arial;
+  margin: 10px 0pt 15px;
+  font-size: 8pt;
+  width: 100%;
+  text-align: left; }
+  table.tablesorter thead tr th, table.tablesorter tfoot tr th {
+    border: 1px solid white;
+    font-size: 8pt;
+    padding: 4px 20px 4px 4px; }
+  table.tablesorter thead tr .header {
+    background-image: url("/images/bg.gif");
+    background-repeat: no-repeat;
+    background-position: center right;
+    cursor: pointer; }
+  table.tablesorter tbody td {
+    color: #3d3d3d;
+    padding: 4px;
+    vertical-align: top; }
+  table.tablesorter tbody tr.odd td {
+    background-color: #fafafa; }
+  table.tablesorter tbody tr.even td {
+    background-color: #fefefe; }
+  table.tablesorter thead tr .headerSortUp {
+    background-image: url("/images/asc.gif"); }
+  table.tablesorter thead tr .headerSortDown {
+    background-image: url("/images/desc.gif"); }
+  table.tablesorter thead tr .headerOver {
+    background-color: #8dbdd8; }
+
+.twenty_pixel_font {
+  font-size: 20px; }
 
 .sixteen_pixel_font {
-	font-size: 16px;
-}
+  font-size: 16px; }
 
 .twelve_pixel_font {
-	font-size: 12px;
-}
+  font-size: 12px; }
 
 .active {
-	color: #000000;
-}
+  color: black; }
 
 .firsttime {
-   position: fixed;
-   top: 0;
-   left: 0;
-   width: 100%;
-   z-index: 100;
-   background: #4dbae6;
-   color: #185b75;
-   font-size: 15px;
-   font-weight: bold;
-   text-align: center;
-   border-bottom: 1px solid #1f7293;
-   padding: 4px;
-   margin-bottom: 8px;
-   display: none;
-}
-
-#cant_decide_options{
-	width:500px;}
+  position: fixed;
+  top: 0;
+  left: 0;
+  width: 100%;
+  z-index: 100;
+  background: #4dbae6;
+  color: #185b75;
+  font-size: 15px;
+  font-weight: bold;
+  text-align: center;
+  border-bottom: 1px solid #1f7293;
+  padding: 4px;
+  margin-bottom: 8px;
+  display: none; }
+
+#cant_decide_options {
+  width: 500px; }
+
 .wider {
-	color: #000000;} 
-  .wider td{
-	  padding: 5px !important}
-
-  .wider td.no_bottom_padding{
-	  padding-bottom: 0px !important;}
-  .wider td.no_top_padding{
-	  padding-top: 0px !important;
-	  vertical-align: top}
-  .wider h2{
-	font-weight: bold;
-	color: #3198c1}
-
-
-#cd_button{
-   background: #C5C5C5;
-   width: 17%; }
-  #cd_button a{
-   color: #FFFFFF;
-   display:block;
-   font-size: 16px;}
+  color: black; }
+  .wider td {
+    padding: 5px !important; }
+    .wider td.no_bottom_padding {
+      padding-bottom: 0px !important; }
+    .wider td.no_top_padding {
+      padding-top: 0px !important;
+      vertical-align: top; }
+  .wider h2 {
+    font-weight: bold;
+    color: #3198c1; }
+
+#cd_button {
+  background: #c5c5c5;
+  width: 17%; }
+  #cd_button a {
+    color: white;
+    display: block;
+    font-size: 16px; }
   #cd_button:hover {
-   background-color: #B1B1B1;
-  }
-
-#cd_button_fr{
-   background: #C5C5C5;
-   width: 21%; }
-  #cd_button_fr a{
-   color: #FFFFFF;
-   display:block;
-   font-size: 16px;}
+    background-color: #b1b1b1; }
+
+/* Messing with here... But nothing is changed right now */
+#cd_button_fr {
+  background: #c5c5c5;
+  width: 21%; }
+  #cd_button_fr a {
+    color: white;
+    display: block;
+    font-size: 12.8px; }
   #cd_button_fr:hover {
-   background-color: #B1B1B1;
-  }
+    background-color: #b1b1b1; }
 
-.cd_submit_button{
+.cd_submit_button {
   padding: 5px 10px 5px 10px;
-  background: #3198C1;
+  background: #3198c1;
   cursor: pointer;
-  color: #FFFFFF;
-  }
+  color: white; }
   .cd_submit_button:hover {
-  background-color: #2B88AD;
-}
-
-.add_idea{
-  margin: 35px 0px 0px 0px;
-  }
- .add_idea .add_idea_button{
-  padding: 5px 10px 5px 10px;
-  width: 265px;
-  height: 3em;
-  display: table-cell;
-  vertical-align: middle;
-  color: #FFFFFF;
-  font-size:16px;
-  cursor: pointer;
-  background: #01bb00;}
- .add_idea .add_idea_button a{
-         color: #FFFFFF;}
- .add_idea .add_idea_button:hover {
-	 background: #228b53;}
- 
+    background-color: #2b88ad; }
+
+/* Messing with here... */
+.add_idea {
+  margin: 5px 0px 0px 0px; }
+  .add_idea .add_idea_button {
+    padding: 2.5px 5px 2.5px 5px;
+    width: 132.5px;
+    height: 1.5em;
+    display: table-cell;
+    vertical-align: middle;
+    color: white;
+    font-size: 12.8px;
+    cursor: pointer;
+    background: #01bb00; }
+    .add_idea .add_idea_button a {
+      color: white; }
+    .add_idea .add_idea_button:hover {
+      background: #228b53; }
 
 #facebox {
-	cursor: move;
-}
+  cursor: move; }
 
-.add_container{
-	height: 9em;
-}
+.add_container {
+  height: 9em; }
 
-.new_idea_submit{
-  padding: 5px 10px 5px 10px;
-  background: #3198C1;
+.new_idea_submit {
+  padding: 2.5px 5px 2.5px 5px;
+  background: #01bb00;
   cursor: pointer;
-  color: #FFFFFF;
-  }
+  color: white;
+  width: 132.5px; }
   .new_idea_submit:hover {
-  background-color: #2B88AD;
-}
+    background-color: #228b53; }
 
-.flag_submit_button{
+.flag_submit_button {
   padding: 5px 10px 5px 10px;
-  background: #3198C1;
+  background: #3198c1;
   cursor: pointer;
-  color: #FFFFFF;
-  }
+  color: white; }
   .flag_submit_button:hover {
-  background-color: #2B88AD;
-}
+    background-color: #2b88ad; }
 
-.no_bottom_padding{
-	  padding-bottom: 0px !important;}
+.no_bottom_padding {
+  padding-bottom: 0px !important; }
diff --git a/vendor/plugins/haml/init.rb b/vendor/plugins/haml/init.rb
index f9fdfdc..3b64a9e 100644
--- a/vendor/plugins/haml/init.rb
+++ b/vendor/plugins/haml/init.rb
@@ -7,7 +7,9 @@ rescue LoadError
     # gems:install may be run to install Haml with the skeleton plugin
     # but not the gem itself installed.
     # Don't die if this is the case.
-    raise e unless defined?(Rake) && Rake.application.top_level_tasks.include?('gems:install')
+    raise e unless defined?(Rake) &&
+      (Rake.application.top_level_tasks.include?('gems') ||
+        Rake.application.top_level_tasks.include?('gems:install'))
   end
 end
 

                   SSUUMMMMAARRYY OOFF LLEESSSS CCOOMMMMAANNDDSS

      Commands marked with * may be preceded by a number, _N.
      Notes in parentheses indicate the behavior if _N is given.

  h  H                 Display this help.
  q  :q  Q  :Q  ZZ     Exit.
 ---------------------------------------------------------------------------

                           MMOOVVIINNGG

  e  ^E  j  ^N  CR  *  Forward  one line   (or _N lines).
  y  ^Y  k  ^K  ^P  *  Backward one line   (or _N lines).
  f  ^F  ^V  SPACE  *  Forward  one window (or _N lines).
  b  ^B  ESC-v      *  Backward one window (or _N lines).
  z                 *  Forward  one window (and set window to _N).
  w                 *  Backward one window (and set window to _N).
  ESC-SPACE         *  Forward  one window, but don't stop at end-of-file.
  d  ^D             *  Forward  one half-window (and set half-window to _N).
  u  ^U             *  Backward one half-window (and set half-window to _N).
  ESC-)  RightArrow *  Left  one half screen width (or _N positions).
  ESC-(  LeftArrow  *  Right one half screen width (or _N positions).
  F                    Forward forever; like "tail -f".
  r  ^R  ^L            Repaint screen.
  R                    Repaint screen, discarding buffered input.
        ---------------------------------------------------
        Default "window" is the screen height.
        Default "half-window" is half of the screen height.
 ---------------------------------------------------------------------------

                          SSEEAARRCCHHIINNGG

  /_p_a_t_t_e_r_n          *  Search forward for (_N-th) matching line.
  ?_p_a_t_t_e_r_n          *  Search backward for (_N-th) matching line.
  n                 *  Repeat previous search (for _N-th occurrence).
  N                 *  Repeat previous search in reverse direction.
  ESC-n             *  Repeat previous search, spanning files.
  ESC-N             *  Repeat previous search, reverse dir. & spanning files.
  ESC-u                Undo (toggle) search highlighting.
  &_p_a_t_t_e_r_n          *  Display only matching lines
        ---------------------------------------------------
        Search patterns may be modified by one or more of:
        ^N or !  Search for NON-matching lines.
        ^E or *  Search multiple files (pass thru END OF FILE).
        ^F or @  Start search at FIRST file (for /) or last file (for ?).
        ^K       Highlight matches, but don't move (KEEP position).
        ^R       Don't use REGULAR EXPRESSIONS.
 ---------------------------------------------------------------------------

                           JJUUMMPPIINNGG

  g  <  ESC-<       *  Go to first line in file (or line _N).
  G  >  ESC->       *  Go to last line in file (or line _N).
  p  %              *  Go to beginning of file (or _N percent into file).
  t                 *  Go to the (_N-th) next tag.
  T                 *  Go to the (_N-th) previous tag.
  {  (  [           *  Find close bracket } ) ].
  }  )  ]           *  Find open bracket { ( [.
  ESC-^F _<_c_1_> _<_c_2_>  *  Find close bracket _<_c_2_>.
  ESC-^B _<_c_1_> _<_c_2_>  *  Find open bracket _<_c_1_> 
        ---------------------------------------------------
        Each "find close bracket" command goes forward to the close bracket 
          matching the (_N-th) open bracket in the top line.
        Each "find open bracket" command goes backward to the open bracket 
          matching the (_N-th) close bracket in the bottom line.

  m_<_l_e_t_t_e_r_>            Mark the current position with <letter>.
  '_<_l_e_t_t_e_r_>            Go to a previously marked position.
  ''                   Go to the previous position.
  ^X^X                 Same as '.
        ---------------------------------------------------
        A mark is any upper-case or lower-case letter.
        Certain marks are predefined:
             ^  means  beginning of the file
             $  means  end of the file
 ---------------------------------------------------------------------------

                        CCHHAANNGGIINNGG FFIILLEESS

  :e [_f_i_l_e]            Examine a new file.
  ^X^V                 Same as :e.
  :n                *  Examine the (_N-th) next file from the command line.
  :p                *  Examine the (_N-th) previous file from the command line.
  :x                *  Examine the first (or _N-th) file from the command line.
  :d                   Delete the current file from the command line list.
  =  ^G  :f            Print current file name.
 ---------------------------------------------------------------------------

                    MMIISSCCEELLLLAANNEEOOUUSS CCOOMMMMAANNDDSS

  -_<_f_l_a_g_>              Toggle a command line option [see OPTIONS below].
  --_<_n_a_m_e_>             Toggle a command line option, by name.
  __<_f_l_a_g_>              Display the setting of a command line option.
  ___<_n_a_m_e_>             Display the setting of an option, by name.
  +_c_m_d                 Execute the less cmd each time a new file is examined.

  !_c_o_m_m_a_n_d             Execute the shell command with $SHELL.
  |XX_c_o_m_m_a_n_d            Pipe file between current pos & mark XX to shell command.
  v                    Edit the current file with $VISUAL or $EDITOR.
  V                    Print version number of "less".
 ---------------------------------------------------------------------------

                           OOPPTTIIOONNSS

        Most options may be changed either on the command line,
        or from within less by using the - or -- command.
        Options may be given in one of two forms: either a single
        character preceded by a -, or a name preceeded by --.

  -?  ........  --help
                  Display help (from command line).
  -a  ........  --search-skip-screen
                  Forward search skips current screen.
  -b [_N]  ....  --buffers=[_N]
                  Number of buffers.
  -B  ........  --auto-buffers
                  Don't automatically allocate buffers for pipes.
  -c  ........  --clear-screen
                  Repaint by clearing rather than scrolling.
  -d  ........  --dumb
                  Dumb terminal.
  -D [_x_n_._n]  .  --color=_x_n_._n
                  Set screen colors. (MS-DOS only)
  -e  -E  ....  --quit-at-eof  --QUIT-AT-EOF
                  Quit at end of file.
  -f  ........  --force
                  Force open non-regular files.
  -F  ........  --quit-if-one-screen
                  Quit if entire file fits on first screen.
  -g  ........  --hilite-search
                  Highlight only last match for searches.
  -G  ........  --HILITE-SEARCH
                  Don't highlight any matches for searches.
  -h [_N]  ....  --max-back-scroll=[_N]
                  Backward scroll limit.
  -i  ........  --ignore-case
                  Ignore case in searches that do not contain uppercase.
  -I  ........  --IGNORE-CASE
                  Ignore case in all searches.
  -j [_N]  ....  --jump-target=[_N]
                  Screen position of target lines.
  -J  ........  --status-column
                  Display a status column at left edge of screen.
  -k [_f_i_l_e]  .  --lesskey-file=[_f_i_l_e]
                  Use a lesskey file.
  -L  ........  --no-lessopen
                  Ignore the LESSOPEN environment variable.
  -m  -M  ....  --long-prompt  --LONG-PROMPT
                  Set prompt style.
  -n  -N  ....  --line-numbers  --LINE-NUMBERS
                  Don't use line numbers.
  -o [_f_i_l_e]  .  --log-file=[_f_i_l_e]
                  Copy to log file (standard input only).
  -O [_f_i_l_e]  .  --LOG-FILE=[_f_i_l_e]
                  Copy to log file (unconditionally overwrite).
  -p [_p_a_t_t_e_r_n]  --pattern=[_p_a_t_t_e_r_n]
                  Start at pattern (from command line).
  -P [_p_r_o_m_p_t]   --prompt=[_p_r_o_m_p_t]
                  Define new prompt.
  -q  -Q  ....  --quiet  --QUIET  --silent --SILENT
                  Quiet the terminal bell.
  -r  -R  ....  --raw-control-chars  --RAW-CONTROL-CHARS
                  Output "raw" control characters.
  -s  ........  --squeeze-blank-lines
                  Squeeze multiple blank lines.
  -S  ........  --chop-long-lines
                  Chop long lines.
  -t [_t_a_g]  ..  --tag=[_t_a_g]
                  Find a tag.
  -T [_t_a_g_s_f_i_l_e] --tag-file=[_t_a_g_s_f_i_l_e]
                  Use an alternate tags file.
  -u  -U  ....  --underline-special  --UNDERLINE-SPECIAL
                  Change handling of backspaces.
  -V  ........  --version
                  Display the version number of "less".
  -w  ........  --hilite-unread
                  Highlight first new line after forward-screen.
  -W  ........  --HILITE-UNREAD
                  Highlight first new line after any forward movement.
  -x [_N[,...]]  --tabs=[_N[,...]]
                  Set tab stops.
  -X  ........  --no-init
                  Don't use termcap init/deinit strings.
                --no-keypad
                  Don't use termcap keypad init/deinit strings.
  -y [_N]  ....  --max-forw-scroll=[_N]
                  Forward scroll limit.
  -z [_N]  ....  --window=[_N]
                  Set size of window.
  -" [_c[_c]]  .  --quotes=[_c[_c]]
                  Set shell quote characters.
  -~  ........  --tilde
                  Don't display tildes after end of file.
  -# [_N]  ....  --shift=[_N]
                  Horizontal scroll amount (0 = one half screen width)

 ---------------------------------------------------------------------------

                          LLIINNEE EEDDIITTIINNGG

        These keys can be used to edit text being entered 
        on the "command line" at the bottom of the screen.

 RightArrow                       ESC-l     Move cursor right one character.
 LeftArrow                        ESC-h     Move cursor left one character.
 CNTL-RightArrow  ESC-RightArrow  ESC-w     Move cursor right one word.
 CNTL-LeftArrow   ESC-LeftArrow   ESC-b     Move cursor left one word.
 HOME                             ESC-0     Move cursor to start of line.
 END                              ESC-$     Move cursor to end of line.
 BACKSPACE                                  Delete char to left of cursor.
 DELETE                           ESC-x     Delete char under cursor.
 CNTL-BACKSPACE   ESC-BACKSPACE             Delete word to left of cursor.
 CNTL-DELETE      ESC-DELETE      ESC-X     Delete word under cursor.
 CNTL-U           ESC (MS-DOS only)         Delete entire line.
 UpArrow                          ESC-k     Retrieve previous command line.
 DownArrow                        ESC-j     Retrieve next command line.
 TAB                                        Complete filename & cycle.
 SHIFT-TAB                        ESC-TAB   Complete filename & reverse cycle.
 CNTL-L                                     Complete filename, list all.


