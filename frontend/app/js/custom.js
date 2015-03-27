$('#git_tree_content').on("select_node.jstree", function(e, data){
  var git_node = data.node.data;
  if(git_node.type === "file"){
  $.ajax('blob/content', {
    type: 'get',
    data: { sha: git_node.sha , key: key},
    success : function(response) {
      $("#git_code").html(response.data);
    },
    error: function() {
      alert("Error");
    }
  });
}
}).jstree({ 'core' : {
  'data' : tree_content 
   } 
});