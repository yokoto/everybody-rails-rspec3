require 'rails_helper'

describe Contact do
	it "is valid with a firstname, lastname and eamil" do
		contact = Contact.new(
			firstname: 'Aaron',
			lastname: 'Sumner',
			email: 'tester@example.com')
			expect(contact).to be_valid  # be_validマッチャを使って、モデルが有効な状態を理解できているかどうかを検証
	end
	it "is invalid without a firstname" do
		contact = Contact.new(firstname: nil)
		contact.valid?
		expect(contact.errors[:firstname]).to include("can't be blank")  # firstname属性にエラーメッセージ(can't be blank)が付いていることを期待する
	end
	it "is invalid without a lastname" do
		contact = Contact.new(lastname: nil)
		contact.valid?
		expect(contact.errors[:lastname]).to include("can't be blank")
	end
	it "is invalid without an email address" do
		contact = Contact.new(email: nil)
		contact.valid?
		expect(contact.errors[:email]).to include("can't be blank")
	end
	it "is invalid with a duplicate email address" do
		Contact.create(  # テストする前に連絡先を保存する
									 firstname: 'Joe', lastname: 'Tester',
									 email: 'tester@example.com'
		)
		contact = Contact.new(  # テスト対象のオブジェクトとしてインスタンス化
								 	 firstname: 'Jane', lastname: 'Tester',
								   email: 'tester@example.com'
		)
		contact.valid?
		expect(contact.errors[:email]).to include("has already been taken")
	end
	it "returns a contact's full name as a string" do
		contact = Contact.new(firstname: 'John', lastname: 'Doe',
													email: 'johndoe@example.com')
		expect(contact.name).to eq 'John Doe'
	end
	describe "filter last name by letter" do 
		before :each do
			@smith = Contact.create(  # ブロックの外側からアクセスできるようにインスタンス変数に設定
				firstname: 'John',
				lastname: 'Smith',
				email: 'jsmith@example.com'
			)
			@jones = Contact.create(
				firstname: 'Tim',
				lastname: 'Jones',
				email: 'tjones@example.com'
			)
			@johnson = Contact.create(
				firstname: 'John',
				lastname: 'Johnson',
				email: 'jjohnson@example.com'
			)
		end
		context "with matching letters" do
			it "returns a sorted array of results that match" do
				expect(Contact.by_letter("J")).to eq [@johnson, @jones]
			end
		end
		context "with non-matching letters" do
			it "omits results that do not match" do
				expect(Contact.by_letter("J")).not_to include @smith
			end
		end
	end
end

