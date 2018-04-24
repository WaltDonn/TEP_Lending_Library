$(document).on('ready', function() {
  function run_ajax(method, data, link, callback=function(res){components.get_components()}){
    $.ajax({
      method: method,
      data: data,
      url: link,
      success: function(res) {
        components.errors = {};
        callback(res);
      },
      error: function(res) {
        console.log("error");
        //components.errors = res.responseJSON;

      }
    })
  };

  // A component describing a row in the components table
  Vue.component('component-row', {
    // Defining where to look for the HTML template in the index view
    template: '#component-row',

    // Passed elements to the component from the Vue instance
    props: {
      component: Object
    },
    // Behaviors associated with this component
    methods: {
      remove_record: function(component){
        run_ajax('DELETE', {component: component}, '/components/'.concat(component['id'], '.js'));
      },
      refill: function (component){
        component['damaged'] = 0;
        component['missing'] = 0;
        run_ajax('PATCH', {component: component}, '/components/'.concat(component['id'], '.js'));
      },
    }
  })

  // instantiate a blank, new instance of Vue.JS
  var components = new Vue({
    el: '#component-list',
    data: {
      components: [],
      modal_open: false,
      errors: {}
    },
    methods: {
      get_components: function(){
        run_ajax('GET', {}, '/components.json', function(res){components.components = res});
      },
      switch_modal: function(event){
        this.modal_open = !(this.modal_open);
      },
    },
    mounted: function(){
      this.get_components();
    }
  });

  var new_form = Vue.component('new-component-form', {
    template: '#new-component-form',
    data: function () {
      return {
        name: '',
        max_quantity: 0,
        damaged: 0,
        missing: 0, 
        consumable: false
      }
    },
    methods: {
      submitForm: function () {
        new_post = {
          name: this.name,
          max_quantity: this.max_quantity,
          damaged: this.damaged,
          missing: this.missing,
          consumable: this.consumable
        }
        run_ajax('POST', {component: new_post}, '/components.json');
      }
    },
  })

  Vue.component('error-row', {
    // Defining where to look for the HTML template in the index view
    template: '#error-row',

    // Passed elements to the component from the Vue instance
    props: {
      error: String,
      msg: Array
    },
  });
});