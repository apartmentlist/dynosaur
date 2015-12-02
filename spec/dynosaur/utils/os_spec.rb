describe Dynosaur::Utils::OS do
  describe '.structured_ps' do
    let(:ps_str) do
      "COMMAND\n" \
      "redis-server\n"
    end

    before do
      allow(Dynosaur::Utils::OS).to receive(:command_ps).and_return(ps_str)
    end

    it 'includes each downcased header' do
      result = Dynosaur::Utils::OS.structured_ps
      expect(result.length).to eq(1)
      expect(result.first.command).to eq('redis-server')
    end

    context 'when there are multiple processes' do
      let(:ps_str) do
        "COMMAND\n" \
        "ruby /bin/h pg ap\n" \
        "ruby /bin/rake fake:task[chocolate] --trace\n"
      end

      it 'returns both processes' do
        result = Dynosaur::Utils::OS.structured_ps
        expect(result.length).to eq(2)
        expect(result[0].command).to eq('ruby /bin/h pg ap')
        expect(result[1].command).to eq('ruby /bin/rake fake:task[chocolate] --trace')
      end
    end
  end
end
