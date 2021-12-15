using System;
using UnityEngine;

namespace ARElements{

public class AnnotationPresenter : MonoBehaviour
{
	private AnnotationScreenCard m_CurrentScreenCard;

	private AnnotationScreenCard m_NextScreenCardPrefab;

	private AnnotationData m_NextScreenCardData;

	public bool isPresentingCard => m_CurrentScreenCard != null;

	public void ShowAnnotationScreenCard(AnnotationData data, AnnotationScreenCard screenCardPrefab)
	{
		if (m_CurrentScreenCard != null)
		{
			m_NextScreenCardData = data;
			m_NextScreenCardPrefab = screenCardPrefab;
			HideAnnotationScreenCard();
		}
		else
		{
			ShowAnnotationScreenCardNow(data, screenCardPrefab);
		}
	}

	public void HideAnnotationScreenCard()
	{
		if (!(m_CurrentScreenCard == null))
		{
			m_CurrentScreenCard.HideCard();
		}
	}

	private void ShowAnnotationScreenCardNow(AnnotationData data, AnnotationScreenCard screenCardPrefab)
	{
		m_CurrentScreenCard = UnityEngine.Object.Instantiate(screenCardPrefab);
		AnnotationScreenCard currentScreenCard = m_CurrentScreenCard;
		currentScreenCard.onCardStateChanged = (Action<AnnotationScreenCard.ScreenCardState>)Delegate.Combine(currentScreenCard.onCardStateChanged, new Action<AnnotationScreenCard.ScreenCardState>(HandleScreenCardStateChange));
		m_CurrentScreenCard.ShowCard(data);
	}

	private void HandleScreenCardStateChange(AnnotationScreenCard.ScreenCardState state)
	{
		if (state == AnnotationScreenCard.ScreenCardState.Hidden)
		{
			DestroyCurrentScreenCard();
			if (!(m_NextScreenCardData == null))
			{
				ShowAnnotationScreenCardNow(m_NextScreenCardData, m_NextScreenCardPrefab);
				m_NextScreenCardData = null;
				m_NextScreenCardPrefab = null;
			}
		}
	}

	private void DestroyCurrentScreenCard()
	{
		if (!(m_CurrentScreenCard == null))
		{
			m_CurrentScreenCard.gameObject.SetActive(value: false);
			UnityEngine.Object.Destroy(m_CurrentScreenCard.gameObject);
			m_CurrentScreenCard = null;
		}
	}
}
}
