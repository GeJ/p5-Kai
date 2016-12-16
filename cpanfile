requires 'perl',            '5.014002';
requires 'File::HomeDir',   '0';
requires 'List::MoreUtils', '0';
requires 'Log::Minimal',    '0';

on 'test' => sub {
    requires 'Test::More',      '0.98';
    requires 'Test::Exception', '0';
    requires 'Test::Requires',  '0';
    requires 'Test::Trap',      'v0.3.2';
};

