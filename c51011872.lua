--トリックスター・ブラッディマリー
function c51011872.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfb),2,2)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c51011872.reccon)
	e1:SetOperation(c51011872.recop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51011872,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,51011872)
	e3:SetCost(c51011872.drcost)
	e3:SetTarget(c51011872.drtg)
	e3:SetOperation(c51011872.drop)
	c:RegisterEffect(e3)
end
function c51011872.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0xfb) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0xfb) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c51011872.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51011872.cfilter,1,nil,e:GetHandler())
end
function c51011872.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,51011872)
	Duel.Recover(tp,200,REASON_EFFECT)
end
function c51011872.costfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0xfb)
end
function c51011872.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51011872.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c51011872.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c51011872.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1
	if Duel.GetLP(tp)>=Duel.GetLP(1-tp)+2000 then ct=2 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c51011872.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
