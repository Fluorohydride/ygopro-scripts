--レーン・リストリクション
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--force mzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_EXTRA)
	e2:SetTarget(s.frctg1)
	e2:SetValue(s.frcval2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_USE_MZONE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetTarget(s.frctg2)
	e3:SetValue(s.frcval2)
	c:RegisterEffect(e3)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,0x10)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x10)
		end
	end
end
function s.frctg1(e,c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_LINK)
end
function s.frctg2(e,c)
	return not (c:IsLocation(LOCATION_EXTRA) and (c:IsFaceup() and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_LINK)))
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function s.frcval1(e,c,fp,rp,r)
	local lzone=Duel.GetLinkedZone(1-e:GetHandlerPlayer())
	for seq=0,4 do
		if (lzone&(1<<seq))~=0
			and not Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_MZONE,seq)
			and Duel.GetLocationCount(1-e:GetHandlerPlayer(),LOCATION_MZONE,1-e:GetHandlerPlayer(),LOCATION_REASON_TOFIELD,1<<seq)>0 then
			return ((1<<seq)*0x10000) | 0x600060
		end
	end
	return 0x600060
end
function s.frcval2(e,c,fp,rp,r)
	local zone=0x0
	for seq=0,4 do
		if not Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_MZONE,seq)
			and Duel.GetLocationCount(1-e:GetHandlerPlayer(),LOCATION_MZONE,1-e:GetHandlerPlayer(),LOCATION_REASON_TOFIELD,1<<seq)>0 then
			return ((1<<seq)*0x10000) | 0x600060
		end
	end
	return 0x600060
end
