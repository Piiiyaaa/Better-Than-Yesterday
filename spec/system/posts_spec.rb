# require 'rails_helper'

# RSpec.describe '投稿機能', type: :system do
#   let(:user) { create(:user) }

#   describe '投稿一覧' do
#     it '投稿一覧ページが表示される' do
#       visit posts_path

#       expect(page).to have_text('投稿')
#       expect(page).to have_current_path(posts_path)
#     end

#     it '投稿がない場合の表示' do
#       visit posts_path

#       expect(page).to have_text('投稿がありません')
#     end

#     it '投稿がある場合の表示' do
#       post = create(:post, user: user, title: 'テスト投稿タイトル', body: 'テスト投稿内容')
#       visit posts_path

#       expect(page).to have_text('テスト投稿タイトル')
#       expect(page).to have_text(user.username)
#       expect(page).to have_link('テスト投稿タイトル', href: post_path(post))
#     end

#     it 'ログイン済みの場合は新規投稿ボタンが表示される' do
#       sign_in user
#       visit posts_path

#       expect(page).to have_link('新規投稿', href: new_post_path)
#     end

#     it 'タグ一覧リンクが表示される' do
#       visit posts_path

#       expect(page).to have_link('タグ一覧', href: tags_path)
#     end
#   end

#   describe '投稿作成' do
#     before { sign_in user }

#     it '投稿作成フォームが表示される' do
#       visit new_post_path

#       expect(page).to have_field('post[learning_date]')
#       expect(page).to have_field('post[title]')
#       expect(page).to have_field('post[body]')
#       expect(page).to have_field('post[tag_names]')
#       expect(page).to have_field('post[daily_question_attributes][body]')
#       expect(page).to have_field('post[daily_question_attributes][question_answer]')
#       expect(page).to have_selector('input[type="submit"]')
#     end

#     it '必須項目を入力して投稿を作成できる' do
#       visit new_post_path

#       fill_in 'post[title]', with: '新しい学習記録'
#       fill_in 'post[body]', with: 'Railsのテストについて学習しました。'
#       fill_in 'post[learning_date]', with: Date.current.strftime('%Y-%m-%d')

#       # 日々の問題も入力
#       fill_in 'post[daily_question_attributes][body]', with: 'Railsのテストフレームワークは何？'
#       fill_in 'post[daily_question_attributes][question_answer]', with: 'RSpec'

#       # type="submit"のinputを直接クリック
#       find('input[type="submit"]').click

#       expect(page).to have_current_path(posts_path)
#       expect(page).to have_text('新しい学習記録')
#     end

#     it 'タグ付きで投稿を作成できる' do
#       visit new_post_path

#       fill_in 'post[title]', with: 'タグ付き投稿'
#       fill_in 'post[body]', with: 'タグ機能のテストです。'
#       fill_in 'post[learning_date]', with: Date.current.strftime('%Y-%m-%d')
#       fill_in 'post[tag_names]', with: 'Rails,テスト,プログラミング'

#       # 日々の問題は必須なので入力
#       fill_in 'post[daily_question_attributes][body]', with: 'テスト問題'
#       fill_in 'post[daily_question_attributes][question_answer]', with: 'テスト答え'

#       find('input[type="submit"]').click

#       expect(page).to have_current_path(posts_path)
#       expect(page).to have_text('タグ付き投稿')
#     end

#     it 'バリデーションエラーが表示される' do
#       visit new_post_path

#       # 必須項目を空のまま送信
#       find('input[type="submit"]').click

#       # バリデーションエラー時は /posts/new に留まる
#       expect(page).to have_current_path(new_post_path)
#       expect(page).to have_field('post[title]')
#     end

#     it 'AIで問題を自動生成ボタンが表示される' do
#       visit new_post_path

#       expect(page).to have_button('AIで問題を自動生成')
#     end
#   end

#   describe '投稿詳細' do
#     let(:daily_question) { create(:daily_question, body: 'テスト問題内容', question_answer: 'テスト答え') }
#     let(:post) { create(:post, user: user, title: '詳細テスト投稿', body: '詳細テスト内容', daily_question: daily_question) }

#     before { sign_in user } # 認証が必要

#     it '投稿詳細ページが表示される' do
#       visit post_path(post)

#       expect(page).to have_text('学びの振り返り詳細')
#       expect(page).to have_text('詳細テスト投稿')
#       expect(page).to have_text('詳細テスト内容')
#       expect(page).to have_text(user.username)
#       expect(page).to have_text(post.learning_date.to_s)
#     end

#     it '今日の一問が表示される' do
#       visit post_path(post)

#       expect(page).to have_text('今日の一問')
#       expect(page).to have_text('テスト問題内容')
#       expect(page).to have_text('解答:')
#       expect(page).to have_text('テスト答え')
#     end

#     it 'シェアボタンが表示される' do
#       visit post_path(post)

#       expect(page).to have_text('この投稿をシェア')
#     end

#     it '投稿者本人の場合は編集・削除ボタンが表示される' do
#       visit post_path(post)

#       expect(page).to have_link('編集', href: edit_post_path(post))
#       expect(page).to have_button('削除')
#     end

#     it '他人の投稿の場合はフォローボタンが表示される' do
#       other_user = create(:user)
#       other_daily_question = create(:daily_question, body: 'テスト問題', question_answer: 'テスト答え')
#       other_post = create(:post, user: other_user, daily_question: other_daily_question)

#       visit post_path(other_post)

#       expect(page).to have_button('フォローする')
#     end
#   end

#   describe '投稿編集' do
#     let(:daily_question) { create(:daily_question, body: 'テスト問題', question_answer: 'テスト答え') }
#     let(:post) { create(:post, user: user, title: '編集前タイトル', body: '編集前内容', daily_question: daily_question) }

#     before { sign_in user }

#     it '投稿編集フォームが表示される' do
#       visit edit_post_path(post)

#       expect(page).to have_field('post[title]', with: '編集前タイトル')
#       expect(page).to have_field('post[body]', with: '編集前内容')
#       expect(page).to have_selector('input[type="submit"]')
#     end

#     it '投稿を編集できる' do
#       visit edit_post_path(post)

#       fill_in 'post[title]', with: '編集後タイトル'
#       fill_in 'post[body]', with: '編集後内容'

#       find('input[type="submit"]').click

#       expect(page).to have_current_path(post_path(post))
#       expect(page).to have_text('編集後タイトル')
#       expect(page).to have_text('編集後内容')
#     end
#   end

#   describe '投稿削除' do
#     let(:daily_question) { create(:daily_question, body: 'テスト問題', question_answer: 'テスト答え') }
#     let(:post) { create(:post, user: user, title: '削除テスト投稿', daily_question: daily_question) }

#     before { sign_in user }

#     it '投稿を削除できる' do
#       visit post_path(post)

#       # JavaScriptの確認ダイアログを受け入れる
#       accept_confirm do
#         click_button '削除'
#       end

#       expect(page).to have_current_path(posts_path)
#       expect(page).not_to have_text('削除テスト投稿')
#     end
#   end

#   describe 'いいね機能' do
#     let(:other_user) { create(:user) }
#     let(:daily_question) { create(:daily_question, body: 'テスト問題', question_answer: 'テスト答え') }
#     let(:post) { create(:post, user: other_user, title: 'いいねテスト投稿', daily_question: daily_question) }

#     before { sign_in user }

#     it 'いいねボタンが表示される' do
#       visit post_path(post)

#       # いいねボタン（ハートアイコン）が表示される
#       expect(page).to have_selector('i.fa-heart')
#     end

#     it 'いいねができる（投稿一覧）' do
#       visit posts_path
#       post # 投稿を作成

#       visit posts_path # ページを再読み込み

#       # いいねボタンをクリック
#       within("#post_#{post.id}_like") do
#         click_button
#       end

#       # いいね後の状態確認（色が変わるなど）
#       expect(page).to have_selector('.text-red-500 i.fa-heart')
#     end
#   end
# end
