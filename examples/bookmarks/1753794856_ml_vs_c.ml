


-- Monlang
{
    var list [1, 2, 3, 4]
    foreach(1 .. len(list) |> map(-), (nth):{
        print("[#" + nth + "]", "=>", list[#nth])
    })
}

-- C
int main()
{
    #define LEN(arr) (sizeof(arr)/sizeof(arr[0]))

    int list[] = {1, 2, 3, 4};
    for (long long i = LEN(list) - 1; i >= 0; --i) {
        printf("[#%lld] => %d\n", i, list[i]);
    }
}

-- C++11
int main()
{
    auto arr = std::array{1, 2, 3, 4};
    for (int i = arr.size() - 1; i >= 0; --i) {
        std::cout << "[#" << i << "] => " << arr[i] << "\n";
    }
}

-- C++23
int main()
{
    using std::views::reverse;
    using std::views::enumerate;

    auto arr = std::array{1, 2, 3, 4};
    for (auto [i, value]: arr | reverse | enumerate) {
        std::println("[#{}] => {}", arr.size() - 1 - i, value);
    }
}
