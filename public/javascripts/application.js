var Body = Behavior.create({
  initialize : function(){
    this.element.addClassName('javascripted')
  }
});

var AuthTypeButton = Behavior.create({
  initialize : function(){
    if (!this.element.checked) {
      $(this.element.id + '_form').hide();
    }
  },
  onclick : function(){
    this.toggle();
  },
  toggle : function(){
    this.hide_forms();
    if (this.element.checked) {
      $(this.element.id + '_form').show();
    }
  },
  hide_forms : function(){
    $$('.auth_form').invoke('hide');
  }
});

var HeaderLogin = Behavior.create({
  initialize : function(){
    this.element.down('form').hide();
  },
  onclick : function(){
    this.element.down('h4').hide();
    this.element.down('form').show();
    $('openid_url').focus();
  }
});

var sidenote_count = 1

var SideNotes = Behavior.create({
  initialize : function(){
    this.element.addClassName('sided');
    var anchor = '[' + sidenote_count + ']';
    new Insertion.Before(this.element, '<sup>' + anchor + '</sup>');
    new Insertion.Top(this.element, anchor + ' ');
    sidenote_count = sidenote_count + 1
  }
});

var Navigation = Behavior.create({
  initialize : function(){
    this.element.select('.nav_section_content').each(function(section){
      section.hide();
    })
    this.element.insert({after: "<div id='current_navigation_content'></div>"})
  }
})

var NavigationTab = Behavior.create({
  onclick: function(){
    this.section = this.element.up('.nav_section');
    this.contents = this.section.down('.nav_section_content');
    if (!this.element.hasClassName('active')) {
      this.defaultOtherTabs();
      this.element.addClassName('active');
      $('current_navigation_content').update(this.contents.innerHTML);
    } 
    else {
      this.element.removeClassName('active');
      $('current_navigation_content').update('');
    }
  },
  defaultOtherTabs: function(){
    $$('.nav_section h2').each(function(h2){
      h2.removeClassName('active');
    })
  }
})

Event.addBehavior({
  'body' : Body,
  'input.auth_type' : AuthTypeButton,
  'sub' : SideNotes,
  '#header_login' : HeaderLogin,
  '#navigation': Navigation,
  '#navigation h2': NavigationTab
});