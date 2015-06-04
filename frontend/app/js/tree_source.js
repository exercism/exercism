if (typeof treeContent === 'undefined') {
  treeContent = '';
}
$('#git-tree-content').on('select_node.jstree', function(e, data){
        var gitNode = data.node.data;
        var sha = gitNode.sha;
        if(gitNode.type === 'file'){
        $.ajax({
          type: 'get',
          dataType: 'json',
          url: '/submissions/'+key+'/blobs/'+sha,
          success : function(response) {
            $('#error-message').html('');
            $('#git-code').html(response.data);
          },
          error: function(xhr, status, error) {
            var errorResponse = JSON.parse(xhr.responseText);
            $('#error-message').html(errorResponse.message);
          }
        });
      }
      }).jstree({ 'core' : {
        'data' : treeContent 
         } 
      });