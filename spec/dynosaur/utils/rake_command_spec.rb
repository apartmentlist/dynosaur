describe Dynosaur::Utils::RakeCommand do
  describe '.parse' do
    let(:result) { Dynosaur::Utils::RakeCommand.parse(command) }

    context 'with no arguments' do
      let(:command) { 'rake fake:task' }

      it 'parses the task name' do
        expect(result.task).to eq('fake:task')
      end

      it 'parses no arguments' do
        expect(result.args).to eq([])
      end

      context 'with leading stuff' do
        let(:command) { 'VAR=val bundle exec rake fake:task' }

        it 'parses the task name' do
          expect(result.task).to eq('fake:task')
        end

        it 'parses no arguments' do
          expect(result.args).to eq([])
        end
      end

      context 'with a trailing flag' do
        let(:command) { 'rake fake:task --trace' }

        it 'parses the task name' do
          expect(result.task).to eq('fake:task')
        end

        it 'parses no arguments' do
          expect(result.args).to eq([])
        end
      end
    end

    context 'with 1 argument' do
      let(:command) { 'rake fake:task[chocolate]' }

      it 'parses the task name' do
        expect(result.task).to eq('fake:task')
      end

      it 'parses the argument' do
        expect(result.args).to eq(['chocolate'])
      end

      context 'with a trailing flag' do
        let(:command) { 'rake fake:task[chocolate] --trace' }

        it 'parses the task name' do
          expect(result.task).to eq('fake:task')
        end

        it 'parses the argument' do
          expect(result.args).to eq(['chocolate'])
        end
      end
    end

    context 'with 2 arguments' do
      let(:command) { 'rake fake:task[chocolate,cheese]' }

      it 'parses the arguments' do
        expect(result.args).to eq(%w[chocolate cheese])
      end
    end

    context 'with a non-rake command' do
      it 'raises an informative ArgumentError' do
        expect do
          Dynosaur::Utils::RakeCommand.parse('brake it all')
        end.to raise_error(ArgumentError, 'Invalid rake command: "brake it all"')
      end
    end
  end

  describe '#to_s' do
    subject { Dynosaur::Utils::RakeCommand.new(task: 'fake:task', args: args) }

    context 'when the task has no arguments' do
      let(:args) { [] }

      it 'returns the correct command line' do
        expect(subject.to_s).to eq('rake fake:task --trace')
      end
    end

    context 'when the task has 1 argument' do
      let(:args) { ['chocolate'] }

      it 'returns the correct command line' do
        expect(subject.to_s).to eq('rake fake:task[chocolate] --trace')
      end
    end

    context 'when the task has 2 arguments' do
      let(:args) { %w[chocolate cheese] }

      it 'returns the correct command line' do
        expect(subject.to_s).to eq('rake fake:task[chocolate,cheese] --trace')
      end
    end
  end

  describe '==' do
    context 'when one has a String arg and the other a Fixnum' do
      subject { Dynosaur::Utils::RakeCommand.new(task: 'fake:task', args: [10]) }

      let(:other) { Dynosaur::Utils::RakeCommand.new(task: 'fake:task', args: ['10']) }

      it 'returns true' do
        expect(subject).to eq(other)
      end
    end
  end
end
