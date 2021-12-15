using System.Collections;
using GoogleARCore.BestPractices;
using UnityEngine;
using UnityEngine.Events;

namespace IslandsDotty
{

	public class LocomotionController : MonoBehaviour
	{
		public class OnLandedEvent : UnityEvent<LocomotionWaypoint>
		{
		}

		public LocomotionWaypoint StartingWaypoint;

		[Tooltip("Speed multiplier for walk, in units per sec.")]
		public float walkSpeed = 10f;

		[Tooltip("Speed multiplier for turning, in radians per sec.")]
		public float turnSpeed = 1f;

		[Tooltip("Speed multiplier for jump, in units per sec.")]
		public float jumpSpeed = 3f;

		public bool startAtWaypoint;

		public bool debug = true;

		[Tooltip("The VFX Trail render to use for Jumping.")]
		public GameObject VFX_JumpTrail;

		private GameObject _VFX_JumpTrail;

		[Tooltip("The VFX to played on the target LocomotionWaypoint.")]
		public GameObject clickImpactTemplate;

		[Tooltip("How long the instantiated clickImpactTemplate lives for.")]
		public float clickImpactLifespan = 2f;

		[Tooltip("The AudioEvent to played on the target LocomotionWaypoint.")]
		public AudioEvent clickImpactAudioEvent;

		[Tooltip("The AudioEvent to play when jumping.")]
		public AudioEvent jumpAudioEvent;

		[Tooltip("The AudioEvent to play when landing from a jump.")]
		public AudioEvent landAudioEvent;

		public OnLandedEvent onLanded = new OnLandedEvent();

		private LocomotionWaypoint _currentWaypoint;

		private LocomotionWaypoint _targetWaypoint;

		private Animator _dottyAC;

		private float _transitDistance;

		private Quaternion _startOrientation;

		private Quaternion _destinationOrientation;

		private bool _blockingAction;

		private bool _isJumping;

		private bool _isWalking;

		private float _locomotionInTransitCoutner;

		private float _locomotionRotateCoutner;

		private float jumpWarmupTime = 0.35f;

		public LocomotionWaypoint CurrentWaypoint
		{
			get
			{
				return _currentWaypoint;
			}
			set
			{
				_currentWaypoint = value;
			}
		}

		public LocomotionWaypoint TargetWaypoint
		{
			get
			{
				return _targetWaypoint;
			}
			set
			{
				_targetWaypoint = value;
			}
		}

		public bool isIdle { get; private set; }

		public bool blockingAction => _blockingAction;

		public bool isJumping
		{
			get
			{
				return _isJumping;
			}
			set
			{
				_isJumping = value;
			}
		}

		public bool isWalking
		{
			get
			{
				return _isWalking;
			}
			set
			{
				_isWalking = value;
			}
		}

		public LocomotionController()
		{
			isIdle = true;
		}

		private void Start()
		{
			_dottyAC = base.transform.GetComponentInChildren<Animator>();
			_startOrientation = base.transform.rotation;
			if (startAtWaypoint && CurrentWaypoint == null && StartingWaypoint != null)
			{
				_currentWaypoint = StartingWaypoint;
				base.transform.position = StartingWaypoint.transform.position;
			}
		}

		private void Update()
		{
			float num = 0f;
			float num2 = 0f;
			float num3 = 0f;
			if (_isJumping)
			{
				Vector3 vector = _targetWaypoint.transform.position - _currentWaypoint.transform.position;
				vector = new Vector3(vector.x / 2f, vector.y / 2f, vector.z / 2f);
				float num4 = Mathf.Abs(_targetWaypoint.transform.position.y - _currentWaypoint.transform.position.y);
				float y = ((!(_transitDistance > num4)) ? (num4 * 2f) : _transitDistance);
				vector = _currentWaypoint.transform.position + new Vector3(vector.x, y, vector.z);
				Vector3[] points = new Vector3[3]
				{
				_currentWaypoint.transform.position,
				vector,
				_targetWaypoint.transform.position
				};
				num3 = jumpSpeed / _transitDistance;
				num = _locomotionInTransitCoutner;
				base.transform.position = QuadraticBezierPlot(num, points);
				_locomotionInTransitCoutner += Time.deltaTime * num3;
				num2 = _locomotionRotateCoutner;
				OrientButStayUpright(1f);
				_locomotionRotateCoutner += Time.deltaTime * turnSpeed;
				if (num >= 0.99f)
				{
					base.transform.position = _targetWaypoint.transform.position;
					Object.DestroyImmediate(_VFX_JumpTrail);
					_dottyAC.SetTrigger("JumpLanded");
					_blockingAction = false;
					_isJumping = false;
					_isWalking = false;
					isIdle = true;
					_currentWaypoint = _targetWaypoint;
					_targetWaypoint = null;
					_transitDistance = 0f;
					if (onLanded != null)
					{
						onLanded.Invoke(_currentWaypoint);
					}
					if ((object)landAudioEvent != null)
					{
						landAudioEvent.PlayAtPoint(base.transform.position);
					}
				}
			}
			if (_isWalking)
			{
				num3 = walkSpeed / _transitDistance;
				num = _locomotionInTransitCoutner;
				base.transform.position = Vector3.Lerp(_currentWaypoint.transform.position, _targetWaypoint.transform.position, num);
				_locomotionInTransitCoutner += Time.deltaTime * num3;
				if (debug)
				{
					Debug.DrawLine(_currentWaypoint.transform.position, _targetWaypoint.transform.position, Color.green);
				}
				num2 = _locomotionRotateCoutner;
				OrientButStayUpright(num2);
				_locomotionRotateCoutner += Time.deltaTime * turnSpeed;
				if (num >= 0.99f)
				{
					_dottyAC.SetTrigger("ResetToIdle");
					StartCoroutine("WaitForCoolDown");
					_isWalking = false;
					_isJumping = false;
					isIdle = true;
					_currentWaypoint = _targetWaypoint;
					_targetWaypoint = null;
					_transitDistance = 0f;
				}
			}
		}

		public void WalkToLocation(LocomotionWaypoint ToLoc)
		{
			_locomotionInTransitCoutner = 0f;
			_locomotionRotateCoutner = 0f;
			_dottyAC.SetTrigger("Walking");
			_targetWaypoint = ToLoc;
			_transitDistance = Vector3.Distance(_currentWaypoint.transform.position, _targetWaypoint.transform.position);
			if (ToLoc != null)
			{
				_isWalking = true;
				_blockingAction = true;
				isIdle = false;
				_isJumping = false;
			}
		}

		public void JumpToLocation(LocomotionWaypoint ToLoc)
		{
			_locomotionInTransitCoutner = 0f;
			_locomotionRotateCoutner = 0f;
			_dottyAC.SetTrigger("BeginJump");
			_targetWaypoint = ToLoc;
			_transitDistance = Vector3.Distance(_currentWaypoint.transform.position, _targetWaypoint.transform.position);
			if (ToLoc != null)
			{
				StartCoroutine("WaitForWarmUp");
				_isJumping = false;
				_blockingAction = true;
				_isWalking = false;
				isIdle = false;
				_VFX_JumpTrail = Object.Instantiate(VFX_JumpTrail, base.transform);
				GameObject obj = Object.Instantiate(clickImpactTemplate, ToLoc.transform);
				Object.Destroy(obj, 2f);
				if ((bool)clickImpactAudioEvent)
				{
					clickImpactAudioEvent.PlayAtPoint(ToLoc.transform.position);
				}
				if ((object)jumpAudioEvent != null)
				{
					jumpAudioEvent.PlayAtPoint(base.transform.position);
				}
			}
		}

		public Vector3 QuadraticBezierPlot(float t, Vector3[] points)
		{
			Vector3 result = default(Vector3);
			result.x = (1f - t) * (1f - t) * points[0].x + 2f * (1f - t) * t * points[1].x + t * t * points[2].x;
			result.y = (1f - t) * (1f - t) * points[0].y + 2f * (1f - t) * t * points[1].y + t * t * points[2].y;
			result.z = (1f - t) * (1f - t) * points[0].z + 2f * (1f - t) * t * points[1].z + t * t * points[2].z;
			return result;
		}

		private void OrientButStayUpright(float OrientProgress)
		{
			Vector3 value = base.transform.position - _currentWaypoint.transform.position;
			if (value.sqrMagnitude > 0f)
			{
				Quaternion b = Quaternion.LookRotation(Vector3.Normalize(value));
				base.transform.rotation = Quaternion.Slerp(_startOrientation, b, OrientProgress);
				base.transform.localEulerAngles = new Vector3(0f, base.transform.localEulerAngles.y, 0f);
			}
		}

		private IEnumerator WaitForWarmUp()
		{
			yield return new WaitForSeconds(jumpWarmupTime);
			_isJumping = true;
			yield return null;
		}

		private IEnumerator WaitForCoolDown()
		{
			yield return new WaitForSeconds(jumpWarmupTime);
			_blockingAction = false;
			yield return null;
		}
	}
}
