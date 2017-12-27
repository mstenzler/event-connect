module ApplicationHelper

  DEFAULT_MALE_AVATAR = 'https://s3.amazonaws.com/crafredcrowds.testing/users/avatars/defaults/male.gif'
  DEFAULT_FEMALE_AVATAR = 'https://s3.amazonaws.com/crafredcrowds.testing/users/avatars/defaults/female.gif'
  DEFAULT_GENERIC_AVATAR = 'https://s3.amazonaws.com/crafredcrowds.testing/users/avatars/defaults/generic.gif'

  def gravatar_url(email, size)
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
  end

  def avatar_url(user, options={})
    size = options[:size] || :thumb
    alt = options[:alt] || ""
    css_class = options[:class] || ""

    url = ""

    if (user && user.avatar_file_name)
      puts "user.avatar = #{user.avatar}"
      url = image_tag(user.avatar.url(size), options)
    else 
      img = ""
      if (user.gender)
        img = case user.gender.downcase
        when 'male'
          DEFAULT_MALE_AVATAR
        when 'female'
          DEFAULT_FEMALE_AVATAR
        else
          DEFAULT_GENERIC_AVATAR
        end
      else
        img = DEFAULT_GENERIC_AVATAR
      end
      url = image_tag(img, options)
    end
#    image_tag rsvp.user.avatar.url(:thumb), alt: "", class: "circle" %>
    url
  end
end
