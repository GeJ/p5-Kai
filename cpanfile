requires 'perl',            '5.008001';
requires 'File::HomeDir',   '0';
requires 'List::MoreUtils', '0';
requires 'Log::Minimal',    '0';

on 'test' => sub {
    requires 'Test::More',      '0.98';
    requites 'Test::Exception', '0';
    requites 'Test::Requires',  '0';
    recommends 'Capture::Tiny', '0';
};

