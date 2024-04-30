class HomeController < ApplicationController
  def addfriend
    commit = params[:commit]
    if commit == "Search"
      @friend_search_result = "";
      search = params[:email]
      if search.to_s.empty?
        puts ""
      elsif search.to_s == current_user.email
        @friend_search_result = "Requesting Yourself ?"
      else 
        query = ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE email=\'" + search + "\'");
        if query.size() > 0   # User Exists
          query = ActiveRecord::Base.connection.execute("SELECT * FROM friendlists WHERE user1=\'" + current_user.email + "\' AND user2=\'" + search + "\'");
          puts query.to_s
          if query.size() > 0 # Already sent request
            if(query.first()["state"] == 2)
              @friend_search_result = "Already a Friend"
            else 
              @friend_search_result = "Already Sent Request to this User"
            end
          else
            query = ActiveRecord::Base.connection.execute("SELECT * FROM friendlists WHERE user2=\'" + current_user.email + "\' AND user1=\'" + search + "\'");
            if query.size() > 0 # Already received request
              if(query.first()["state"] == 2)
                @friend_search_result = "Already a Friend"
              else 
                @friend_search_result = "Already Received Request from this User"
              end
            else
              @friend_search_result = search;
            end
          end
        else
          @friend_search_result = "No such User"
        end
      end
    elsif commit == "Add" 
      sender = current_user.email
      receiver = params[:email]
      query = ActiveRecord::Base.connection.execute("SELECT friendlists.user1 FROM friendlists")
      exist = false
      query.each do |element|
        if element.first().second() == search
          @friend_search_result = search
          break
        end
      end
      if !exist
        time = Time.now
        curtime = time.strftime("%Y-%m-%d %H:%M:%S").to_s;
        query = "INSERT INTO friendlists(user1, user2, state, created_at, updated_at) VALUES(\'"+sender.to_s+"\',\'"+receiver.to_s+"\',1,\'" + curtime + "\',\'" + curtime + "\')"
        ActiveRecord::Base.connection.execute(query)
      end
      redirect_to "/home/addfriend"
    else
      @friend_search_result = "";
    end
  end

  def acceptfriend
    commit = params[:commit]
    sender = params[:email]
    if commit == "Accept"
      time = Time.now
      curtime = time.strftime("%Y-%m-%d %H:%M:%S").to_s;
      query = "UPDATE friendlists SET state=2, updated_at=\'" + curtime + "\' WHERE user2=\'" + current_user.email + "\' AND user1 = \'" + sender.to_s + "\'"
      ActiveRecord::Base.connection.execute(query);
    elsif commit == "Reject"
      sender = params[:email]
      query = "DELETE FROM friendlists WHERE user2=\'" + current_user.email + "\' AND user1 = \'" + sender.to_s + "\'"
      ActiveRecord::Base.connection.execute(query);
    end
  end

  def deletefriend
    sender = params[:email]
    query = "DELETE FROM friendlists WHERE user2=\'" + current_user.email + "\' AND user1 = \'" + sender.to_s + "\'"
    ActiveRecord::Base.connection.execute(query);
    query = "DELETE FROM friendlists WHERE user1=\'" + current_user.email + "\' AND user2 = \'" + sender.to_s + "\'"
    ActiveRecord::Base.connection.execute(query);
  end
end
