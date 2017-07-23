--メタファイズ・ダイダロス
function c45960523.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45960523,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c45960523.rmcon)
	e1:SetTarget(c45960523.rmtg)
	e1:SetOperation(c45960523.rmop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45960523,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c45960523.rmcon2)
	e2:SetCost(c45960523.rmcost2)
	e2:SetTarget(c45960523.rmtg2)
	e2:SetOperation(c45960523.rmop2)
	c:RegisterEffect(e2)
end
function c45960523.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x105)
end
function c45960523.rmfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove() and c:IsFaceup()
end
function c45960523.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c45960523.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c45960523.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c45960523.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c45960523.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c45960523.rmcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c45960523.rmfilter2(c)
	return c:IsSetCard(0x105) and not c:IsCode(45960523) and c:IsAbleToRemove()
end
function c45960523.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45960523.rmfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c45960523.rmop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c45960523.rmfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
