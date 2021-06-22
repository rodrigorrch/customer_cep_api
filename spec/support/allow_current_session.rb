module AllowCurrentSession
  def allow_current_session_user
    let(:user) { create(:user) }

    before do
      allow(CurrentSession).to receive(:user).and_return(user)
    end
  end
end
