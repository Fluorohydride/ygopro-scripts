--スケアクロー・アクロア
function c46877100.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,46877100+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c46877100.hspcon)
	e1:SetValue(c46877100.hspval)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c46877100.atktg)
	e2:SetValue(c46877100.atkval)
	c:RegisterEffect(e2)
end
function c46877100.cfilter(c)
	return c:IsSetCard(0x17a) and c:IsFaceup()
end
function c46877100.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c46877100.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=aux.MZoneSequence(tc:GetSequence())
		zone=zone|(1<<seq)
		if seq>0 then zone=zone|(1<<(seq-1)) end
		if seq<4 then zone=zone|(1<<(seq+1)) end
	end
	return zone
end
function c46877100.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c46877100.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c46877100.hspval(e,c)
	local tp=c:GetControler()
	return 0,c46877100.getzone(tp)
end
function c46877100.atktg(e,c)
	return c:IsSetCard(0x17a) and c:GetSequence()>=5
end
function c46877100.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsDefensePos,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
