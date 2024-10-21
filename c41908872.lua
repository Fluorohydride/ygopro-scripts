--覇王眷竜ライトヴルム
function c41908872.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41908872,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_ACTIVATE_CONDITION)
	e1:SetCountLimit(1,41908872)
	e1:SetCondition(c41908872.spcon)
	e1:SetTarget(c41908872.sptg)
	e1:SetOperation(c41908872.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41908872,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,41908873)
	e2:SetTarget(c41908872.thtg1)
	e2:SetOperation(c41908872.thop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(41908872,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,41908874)
	e4:SetCondition(c41908872.thcon2)
	e4:SetTarget(c41908872.thtg2)
	e4:SetOperation(c41908872.thop2)
	c:RegisterEffect(e4)
end
function c41908872.cfilter1(c,tp)
	return c:IsCode(13331639) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c41908872.cfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c41908872.cfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c41908872.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c41908872.cfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c41908872.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c41908872.filter(c,ec)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLevelAbove(0)
		and (not c:IsAttribute(ec:GetAttribute()) or not c:IsLevel(ec:GetLevel()))
end
function c41908872.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c41908872.filter,tp,LOCATION_MZONE,0,c,c)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(41908872,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local rc=g:Select(tp,1,1,c):GetFirst()
			local rg=Group.FromCards(c,rc)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(41908872,4))
			local sg=rg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			local sc=(rg-sg):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(sc:GetAttribute())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(sc:GetLevel())
			tc:RegisterEffect(e2)
		end
	end
end
function c41908872.thfilter(c)
	return c:IsSetCard(0x10f8,0x20f8) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function c41908872.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41908872.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c41908872.scfilter(c)
	return c:IsSetCard(0x20f8) and c:IsSynchroSummonable(nil)
end
function c41908872.xyzfilter(c)
	return c:IsSetCard(0x20f8) and c:IsXyzSummonable(nil)
end
function c41908872.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c41908872.thfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT) and tc:IsLocation(LOCATION_HAND) then
		local g1=Duel.GetMatchingGroup(c41908872.scfilter,tp,LOCATION_EXTRA,0,nil)
		local g2=Duel.GetMatchingGroup(c41908872.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if (g1:GetCount()>0 or g2:GetCount()>0)
			and Duel.SelectYesNo(tp,aux.Stringid(41908872,5)) then
			Duel.BreakEffect()
			local g=g1+g2
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if g1:IsContains(sc) then
				Duel.SynchroSummon(tp,sc,nil)
			else
				Duel.XyzSummon(tp,sc,nil)
			end
		end
	end
end
function c41908872.thfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP)
end
function c41908872.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c41908872.thfilter2,1,c,tp) and not eg:IsContains(c) and c:IsFaceup()
end
function c41908872.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c41908872.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
