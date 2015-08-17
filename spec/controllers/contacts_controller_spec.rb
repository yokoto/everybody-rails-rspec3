require 'rails_helper'

describe ContactsController do

	describe 'GET #index' do
		context 'with params[:letter]' do
			it "populates an array of contacts starting with the letter" do
				smith = create(:contact, lastname: 'Smith')
				jones = create(:contact, lastname: 'Jones')
				get :index, letter: 'S'
				expect(assigns(:contacts)).to match_array([smith])
				# 頭文字検索に合致した連絡先の配列が作られ、それが@contactsに割り当てられることをチェック
				# match_arrayマッチャを使って、コレクション(@contactsにassignされた値)が期待する値になっていることをチェック。exampleの中で作られたsmithが一つだけ含まれている配列を探す。
			end
			it "renders the :index template" do
				get :index, letter: 'S'
				expect(response).to render_template :index
				# responseを経由してindex.html.erbテンプレートが表示されていることを確認している。
			end
		end

		context 'without params[:letter]' do
			it "populates an array of all contacts" do
				smith = create(:contact, lastname: 'Smith')
				jones = create(:contact, lastname: 'Jones')
				get :index
				expect(assigns(:contacts)).to match_array([smith, jones])
				# 文字をパラメータとしてメソッドに渡していないので、作成された両方の連絡先が返されることになる。
			end
			it "renders the :index template" do
				get :index
				expect(response).to render_template :index
			end
		end
	end

	describe 'GET #show' do
		it "assigns the requested contact to @contact" do
		  contact = create(:contact)
			get :show, id: contact
			expect(assigns(:contact)).to eq contact  
			# コントローラのメソッドが保存済みの連絡先を見つけ、それが特定のインスタンス変数に正しく割り当てていることをチェック
		end
		it "renders the :show template" do
		  contact = create(:contact)
			phone = create(:phone, contact: contact)
			get :show, id: phone, contact_id: contact.id
			expect(response).to render_template :show
			# コントローラからブラウザに返されるレスポンスがshow.html.erbテンプレートを使って表示されることをチェック
		end
	end

	describe 'GET #new' do
		it "assigns a new Contact to @contact" do
			get :new
			expect(assigns(:contact)).to be_a_new(Contact)
		end
		it "renders the :new template" do
			get :new
			expect(response).to render_template :new
		end
	end

	describe 'GET #edit' do
		it "assigns the requested contact to @contact" do
			contact = create(:contact)
			get :edit, id: contact
			expect(assigns(:contact)).to eq contact
		end
		it "renders the :edit template" do
			contact = create(:contact)
			get :edit, id: contact
			expect(response).to render_template :edit
		end
	end

	describe "POST #create" do
		before :each do 
			# Contactモデルにはバリデーションの要件として、三つの電話番号を持たなければいけない。POSTリクエストに渡す電話番号の属性を三つまとめて一つの配列にしている。
			@phones = [
				attributes_for(:phone),
				attributes_for(:phone),
				attributes_for(:phone)
			]
		end
		context "with valid attributes" do
			it "saves the new contact in the database" do
				# HTTPリクエスト全体をexpectのブロックに渡している。このHTTPリクエストはProcとして渡され、その結果が実行前と実行後の両方で評価される。
				expect{
					post :create, contact: attributes_for(:contact,
						phones_attributes: @phones)
				}.to change(Contact, :count).by(1)
				# オブジェクトが生成され、保存されることをテスト
			end
			it "redirects to contacts#show" do
				post :create, contact: attributes_for(:contact,
				  phones_attributes: @phones)
				expect(response).to redirect_to contact_path(assigns[:contact])
			end
		end

		context "with invalid attributes" do
			it "does not save the new contact in the database" do
				expect{
					post :create,
					  contact: attributes_for(:invalid_contact)
				}.not_to change(Contact, :count)
		  end
			it "re-renders the :new template" do
				post :create,
					contact: attributes_for(:invalid_contact)
				expect(response).to render_template :new
			end
		end
  end

	describe 'PATCH #update' do
		# 既存のContactを更新するので、あとでアクセスできるように保存したContactを@contactに割り当てている。
			before :each do 
				@contact = create(:contact,
				  firstname: 'Lawrence',
					lastname: 'Smith')
			end

		context "with valid attributes" do
		  it "locates the requested @contact" do
				patch :update, id: @contact, contact: attributes_for(:contact)
				expect(assigns(:contact)).to eq(@contact)
			end

			it "changes @contact's attributes" do
				patch :update, id: @contact,
					contact: attributes_for(:contact,
						firstname: 'Larry',
						lastname: 'Smith')
				@contact.reload  # 更新内容が本当に保存されたかどうかをチェック
				expect(@contact.firstname).to eq('Larry')
				expect(@contact.lastname).to eq('Smith')
			end
			it "redirects to the updated contact" do
				patch :update, id: @contact, contact: attributes_for(:contact)
				expect(response).to redirect_to @contact
			end
		end

		context "with invalid attributes" do
			it "does not change the contact's attributes" do
				patch :update, id: @contact,
					contact: attributes_for(:contact,
				    firstname: "Larry", lastname: nil)
				@contact.reload
				expect(@contact.firstname).not_to eq("Larry")
				expect(@contact.lastname).to eq("Smith")
			end
			it "re-renders the :edit template" do
				patch :update, id: @contact,
					contact: attributes_for(:invalid_contact)
				expect(response).to render_template :edit
			end
		end
  end

	describe 'DELETE #destroy' do
		before :each do
			@contact = create(:contact)
		end

		it "deletes the contact" do
		  expect{
				delete :destroy, id: @contact
			}.to change(Contact, :count).by(-1)
		end
		it "redirects to contacts#index" do
			delete :destroy, id: @contact
			expect(response).to redirect_to contacts_url
		end
	end
end

