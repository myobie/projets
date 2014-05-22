@app or= {}

class app.Comment extends Backbone.Model
  excerpt: ->
    content = @get("content")
    shorter_content = content.substring 0, 50
    shorter_content += "..." unless shorter_content is content
    shorter_content
