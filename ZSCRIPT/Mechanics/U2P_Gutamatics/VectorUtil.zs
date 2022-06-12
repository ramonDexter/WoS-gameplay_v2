class U2P_VectorUtil {
	/// Linearly interpolates between two Vector3s, clamping the parameters.
	static Vector3 lerpVec3(Vector3 from, Vector3 to, double time) {
		time = clamp(time, 0, 1);
		return lerpUnclampedVec3(from, to, time);
	}
	
	/// Linearly interpolates between two Vector3s.
	static Vector3 lerpUnclampedVec3(Vector3 from, Vector3 to, double time) {
		Vector3 ret;
		double reverseTime = 1 - time;
		ret = reverseTime * from + time * to;
		return ret;
	}
	
	/// Linearly interpolates between two Vector2s, clamping the parameters.
	static Vector2 lerpVec2(Vector2 from, Vector2 to, double time) {
		time = clamp(time, 0, 1);
		return lerpUnclampedVec2(from, to, time);
	}
	
	/// Linearly interpolates between two Vector2s.
	static Vector2 lerpUnclampedVec2(Vector2 from, Vector2 to, double time) {
		Vector2 ret;
		double reverseTime = 1 - time;
		ret = reverseTime * from + time * to;
		return ret;
	}
}