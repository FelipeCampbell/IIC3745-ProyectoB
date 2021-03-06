module ApplicationHelper

  def link_to_add_fields(name, f, association )
    #get o
    new_movie = f.object.send(association).klass.new
    id = new_movie.object_id

    fields = f.fields_for(association, new_movie, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, "#", id: 0, class: 'add_fields', data: {id:id, fields: fields.gsub("\n", "")})
  end

end
