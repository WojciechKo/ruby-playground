RSpec.describe 'Proc composition' do
  context 'with lambdas' do
    let(:append_exclamation_mark) { ->(string) { "#{string}!" } }
    let(:append_question_mark) { ->(string) { "#{string}?" } }
    let(:append_dot) { ->(string) { "#{string}." } }

    describe '#>>' do
      it 'executes in given order' do
        expect(append_exclamation_mark.call('Alfa'))
          .to eq('Alfa!')

        expect((append_exclamation_mark >> append_question_mark).call('Alfa'))
          .to eq('Alfa!?')

        expect((append_exclamation_mark >> append_question_mark >> append_dot).call('Alfa'))
          .to eq('Alfa!?.')
      end
    end

    describe '#<<' do
      it 'executes in reversed order' do
        expect(append_exclamation_mark.call('Alfa'))
          .to eq('Alfa!')

        expect((append_exclamation_mark << append_question_mark).call('Alfa'))
          .to eq('Alfa?!')

        expect((append_exclamation_mark << append_question_mark << append_dot).call('Alfa'))
          .to eq('Alfa.?!')
      end
    end
  end

  context 'with objects that responds to #call' do
    context 'with #>> and #<< methods defined by composed objects' do
      before do
        stub_const('Composable', Module.new do
          def <<(other)
            proc { |*args, &blk| call(other.call(*args, &blk)) }
          end

          def >>(other)
            proc { |*args, &blk| other.call(call(*args, &blk)) }
          end
        end)

        stub_const('ExclamationMarkAppender', Class.new do
          extend Composable

          def self.call(string)
            "#{string}!"
          end
        end)

        stub_const('QuestionMarkAppender', Class.new do
          include Composable

          def call(string)
            "#{string}?"
          end
        end)
      end

      describe '#>>' do
        it 'executes in given order' do
          expect(ExclamationMarkAppender.call('Alfa'))
            .to eq('Alfa!')

          expect((ExclamationMarkAppender >> QuestionMarkAppender.new)
            .call('Alfa')).to eq('Alfa!?')
        end
      end

      describe '#<<' do
        it 'executes in reversed order' do
          expect(ExclamationMarkAppender.call('Alfa'))
            .to eq('Alfa!')

          expect((ExclamationMarkAppender << QuestionMarkAppender.new).call('Alfa'))
            .to eq('Alfa?!')
        end
      end
    end

    context 'with #to_proc method defined by composed objects' do
      before do
        stub_const('Procable', Module.new do
          def to_proc
            proc { |*args, &block| call(*args, &block) }
          end
        end)

        stub_const('ExclamationMarkAppender', Class.new do
          extend Procable

          def self.call(string)
            "#{string}!"
          end
        end)

        stub_const('QuestionMarkAppender', Class.new do
          include Procable

          def call(string)
            "#{string}?"
          end
        end)
      end

      describe '#>>' do
        it 'executes in given order' do
          expect(ExclamationMarkAppender.call('Alfa'))
            .to eq('Alfa!')

          expect((ExclamationMarkAppender.to_proc >> QuestionMarkAppender.new)
            .call('Alfa')).to eq('Alfa!?')
        end
      end

      describe '#<<' do
        it 'executes in reversed order' do
          expect(ExclamationMarkAppender.call('Alfa'))
            .to eq('Alfa!')

          expect((ExclamationMarkAppender.to_proc << QuestionMarkAppender.new).call('Alfa'))
            .to eq('Alfa?!')
        end
      end
    end
  end

  context 'with Method objects' do
    before do
      stub_const('StringUtil', Class.new do
        def self.append_exclamation_mark(string)
          "#{string}!"
        end

        def self.append_question_mark(string)
          "#{string}?"
        end
      end)
    end

    describe '#>>' do
      it 'executes in given order' do
        expect(StringUtil.method(:append_exclamation_mark).call('Alfa'))
          .to eq('Alfa!')

        expect((StringUtil.method(:append_exclamation_mark) >> StringUtil.method(:append_question_mark)).call('Alfa'))
          .to eq('Alfa!?')
      end
    end

    describe '#<<' do
      it 'executes in reversed order' do
        expect(StringUtil.method(:append_exclamation_mark).call('Alfa'))
          .to eq('Alfa!')

        expect((StringUtil.method(:append_exclamation_mark) << StringUtil.method(:append_question_mark)).call('Alfa'))
          .to eq('Alfa?!')
      end
    end
  end
end
