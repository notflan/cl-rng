extern crate getrandom;

use getrandom::*;

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn it_works() {
	let mut f: f64 = 0.0;
	assert_eq!(sample(&mut f as *mut f64), 1);
    }
}

fn get<T: Default>() -> Result<T, Error>
{
    let mut value: T = Default::default();
    unsafe {
	let mut slice = std::slice::from_raw_parts_mut(&mut value as *mut T as *mut u8, std::mem::size_of::<T>());
	populate(&mut slice)?;
    }
    
    Ok(value)
}

fn double() -> Result<f64, Error>
{
    let long: i64 = get::<i64>()?;

    Ok( ((long & ((1i64 << 53) - 1)) as f64) * (1_f64 / ((1_i64 << 53) as f64)))
}

fn populate(mut value: &mut [u8]) -> Result<(), Error>
{
    getrandom(&mut value)?;

    Ok(())
}

#[no_mangle]
pub extern "C" fn sample(value: *mut f64) -> i32
{
    match std::panic::catch_unwind(|| {
	unsafe {
	    match double() {
		Ok(x) => *value = x,
		Err(_) => return 0,
	    }
	}
	1
    }) {
	Ok(v) => v,
	Err(_) => 0,
    }
}

