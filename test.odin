package sprawl

import "core:fmt"

main :: proc () {
    sprawl_arr := create(int, 2, 2, 2, 2, 2, 2);

    o := 0;

    for i in 0..<2 {
        for j in 0..<2 {
            for k in 0..<2 {
                for l in 0..<2 {
                    for m in 0..<2 {
                        for n in 0..<2 {
                            set(sprawl_arr, o, i, j, k, l, m, n);
                            fmt.print(ref(sprawl_arr, i, j, k, l, m, n)^);
                            fmt.print(" ");
                            o += 1;
                        }
                        fmt.println();
                    }
                    fmt.println();
                }
            }
        }
    }

    fmt.println(sprawl_arr.data);
    fmt.printf("o: {0}\n", o);
}