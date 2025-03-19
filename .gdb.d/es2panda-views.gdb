define pj
    printf "%s\n", (char*)($arg0)->DumpJSON()
end

define ps
    printf "%s\n", (char*)($arg0)->DumpEtsSrc()
end

define pt
    printf "%s\n", (char*)((ark::es2panda::checker::Type*)($arg0))->ToString()
end

define psig
    printf "%s\n", (char*)((ark::es2panda::checker::Signature*)($arg0))->ToString()
end
