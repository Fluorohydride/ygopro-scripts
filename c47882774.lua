--ウォークライ・ディグニティ
---@param c Card
function c47882774.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47882774,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,47882774+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47882774.actcon)
	e1:SetTarget(c47882774.acttg)
	e1:SetOperation(c47882774.actop)
	c:RegisterEffect(e1)
end
function c47882774.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c47882774.actcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(c47882774.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and ((re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE)
			or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
				and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))))
end
function c47882774.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47882774.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
