--黄紡鮄デュオニギス
function c79724755.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79724755,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79724755)
	e1:SetTarget(c79724755.rmtg)
	e1:SetOperation(c79724755.rmop)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79724755,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,79724756)
	e2:SetTarget(c79724755.lvtg)
	e2:SetOperation(c79724755.lvop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79724755,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,79724757)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79724755.atktg)
	e3:SetOperation(c79724755.atkop)
	c:RegisterEffect(e3)
end
function c79724755.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c79724755.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c79724755.cfilter,tp,LOCATION_MZONE,0,nil)
	local dg=Duel.GetDecktopGroup(1-tp,ct)
	if chk==0 then return ct>0 and ct>0 and dg:FilterCount(Card.IsAbleToRemove,nil)==ct end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,#dg,0,0)
end
function c79724755.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c79724755.cfilter,tp,LOCATION_MZONE,0,nil)
	local dg=Duel.GetDecktopGroup(1-tp,ct)
	if #dg>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	end
end
function c79724755.lvfilter(c)
	return c:IsLevelBelow(4) and c79724755.cfilter(c)
end
function c79724755.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79724755.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79724755.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79724755.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79724755.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(tc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c79724755.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c79724755.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79724755.cfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.IsExistingMatchingCard(c79724755.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c79724755.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c79724755.cfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c79724755.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*100)
		tc:RegisterEffect(e1)
	end
end
