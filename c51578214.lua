--騎甲虫アサルト・ローラー
function c51578214.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51578214+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c51578214.spcon)
	e1:SetTarget(c51578214.sptg)
	e1:SetOperation(c51578214.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c51578214.atkup)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,51578215)
	e3:SetTarget(c51578214.sctg)
	e3:SetOperation(c51578214.scop)
	c:RegisterEffect(e3)
end
function c51578214.spcostfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_INSECT)
end
function c51578214.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c51578214.spcostfilter1,tp,LOCATION_GRAVE,0,nil)
	return #g>0
end
function c51578214.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c51578214.spcostfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c51578214.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.Remove(sg,POS_FACEUP,REASON_SPSUMMON)
end
function c51578214.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c51578214.atkup(e,c)
	return Duel.GetMatchingGroupCount(c51578214.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())*200
end
function c51578214.filter(c)
	return c:IsSetCard(0x170) and c:IsType(TYPE_MONSTER) and not c:IsCode(51578214) and c:IsAbleToHand()
end
function c51578214.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51578214.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51578214.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51578214.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
