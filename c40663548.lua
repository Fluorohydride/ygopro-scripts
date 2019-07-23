--アロマージ－マジョラム
function c40663548.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40663548,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40663548)
	e1:SetCondition(c40663548.spcon)
	e1:SetTarget(c40663548.sptg)
	e1:SetOperation(c40663548.spop)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c40663548.bdcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40663548,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40663549)
	e3:SetCondition(c40663548.rmcon)
	e3:SetTarget(c40663548.rmtg)
	e3:SetOperation(c40663548.rmop)
	c:RegisterEffect(e3)
end
function c40663548.cfilter(c,tp)
	return c:IsRace(RACE_PLANT) and c:GetPreviousControler()==tp
end
function c40663548.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40663548.cfilter,1,nil,tp)
end
function c40663548.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c40663548.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
function c40663548.bdcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c40663548.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c40663548.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc9)
end
function c40663548.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c40663548.ctfilter,tp,LOCATION_MZONE,0,nil)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	end
end
function c40663548.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
