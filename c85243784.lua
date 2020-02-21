--リンクロス
function c85243784.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c85243784.mfilter,1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85243784,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,85243784)
	e1:SetCondition(c85243784.tkcon)
	e1:SetTarget(c85243784.tktg)
	e1:SetOperation(c85243784.tkop)
	c:RegisterEffect(e1)
end
function c85243784.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2
end
function c85243784.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c85243784.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,48068379,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	e:SetLabel(mg:GetFirst():GetLink())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c85243784.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,48068379,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85243784,1))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,85243785)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count==0
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,48068379))
	e1:SetValue(c85243784.lklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c85243784.lklimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
