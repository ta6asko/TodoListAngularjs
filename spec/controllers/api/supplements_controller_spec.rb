require 'controllers/controllers_spec_helper'

describe Api::SupplementsController do
  
  let(:supplement_attrs) { attributes_for(:supplement) }
  
  before do
    @user = create(:user)
    allow(controller).to receive(:current_user) { @user }
    @project = create(:project, user_id: @user.id)
    @task = create(:task, project_id: @project.id)
    @comment = create(:comment, task_id: @task.id)
    @supplement = create(:supplement, comment_id: @comment.id)
    redefine_cancan_abilities
  end

  describe "POST #create" do

    context 'being signed in' do

      before do
        sign_in @user
      end

      it "responds successfully with an HTTP 200 status code" do
        post :create, comment_id: @comment.id, supplement: supplement_attrs
        expect(response.status).to eq(200)
      end

    end

    context 'being not signed in' do
      
      before do
        post :create, comment_id: @comment.id, supplement: supplement_attrs
      end

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context 'cancan doesnt allow :create' do
      before do
        sign_in @user
        @ability.cannot :create, Supplement
        post :create, comment_id: @comment.id, supplement: supplement_attrs 
      end

      it { should redirect_to root_path }
    end
  end

  describe "DELETE #destroy" do
    context 'being signed in' do

      before do
        sign_in @user
      end

      it "responds successfully with an HTTP 200 status code" do
        
        delete :destroy, id: @supplement.id, comment_id: @comment.id, supplement: supplement_attrs 
      end
    end

    context 'being not signed in' do
      
      before do
        delete :destroy, id: @supplement.id, comment_id: @comment.id, supplement: supplement_attrs 
      end

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context 'cancan doesnt allow :destroy' do
      before do
        sign_in @user
        @ability.cannot :destroy, Supplement
        delete :destroy, id: @supplement.id, comment_id: @comment.id, supplement: supplement_attrs 
      end

      it { should redirect_to root_path }
    end
  end
end