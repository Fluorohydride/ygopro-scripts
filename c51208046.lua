--トリックスター・ライブステージ
function c51208046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c51208046.target)
	e1:SetOperation(c51208046.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51208046,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,51208046)
	e2:SetCost(c51208046.cost)
	e2:SetCondition(c51208046.spcon1)
	e2:SetTarget(c51208046.sptg)
	e2:SetOperation(c51208046.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(51208046,2))
	e3:SetCountLimit(1,51208047)
	e3:SetCondition(c51208046.spcon2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(51208046,ACTIVITY_SPSUMMON,c51208046.counterfilter)
end
function c51208046.counterfilter(c)
	return c:IsSetCard(0xfb)
end
function c51208046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(51208046,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c51208046.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c51208046.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xfb)
end
function c51208046.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfb) and c:IsAbleToHand()
end
function c51208046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c51208046.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c51208046.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(51208046,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c51208046.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xfb) and c:IsType(TYPE_LINK)
end
function c51208046.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51208046.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c51208046.cfilter2(c)
	return c:GetSequence()<5
end
function c51208046.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51208046.cfilter2,tp,0,LOCATION_SZONE,1,nil)
end
function c51208046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,51208047,0xfb,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c51208046.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,51208047,0xfb,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,51208047)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
