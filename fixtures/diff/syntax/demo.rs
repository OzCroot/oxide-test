/// Adds two numbers.
#[inline]
fn add(a: i32, b: i32) -> i32 {
    a.wrapping_add(b)
}

/*
 * Legacy notes, kept for reference.
 * The old version used a lookup table.
 * It was removed in 2025.
 * Nothing here is compiled.
 * Do not delete until the audit ends.
 * Contact the platform team for details.
 * Last edited by someone long gone.
 */
fn legacy() {}

fn main() {
    let total = add(1, 2);
    println!("total = {}", total);
}
