--ホルスの祝福－ドゥアムテフ
function c11335209.initial_effect(c)
	aux.AddCodeList(c,16528181)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,11335209+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11335209.sprcon)
	c:RegisterEffect(e1)
	--buff
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c11335209.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Leave Field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11335209,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,11335210)
	e4:SetCondition(c11335209.descon)
	e4:SetTarget(c11335209.destg)
	e4:SetOperation(c11335209.desop)
	c:RegisterEffect(e4)
end
function c11335209.sprfilter(c)
	return c:IsFaceup() and c:IsCode(16528181)
end
function c11335209.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11335209.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c11335209.bfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x19d)
end
function c11335209.atkval(e,c)
	return Duel.GetMatchingGroupCount(c11335209.bfilter,c:GetControler(),LOCATION_MZONE,0,nil)*1200
end
function c11335209.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end
function c11335209.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11335209.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c11335209.drfilter(c,tp)
	return c:GetSequence()<5 and c:IsFaceup()
end
function c11335209.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c11335209.drfilter,tp,LOCATION_MZONE,0,nil)
		local ct=c11335209.count_unique_code(g)
		e:SetLabel(ct)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c11335209.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11335209.drfilter,tp,LOCATION_MZONE,0,nil)
	local ct=c11335209.count_unique_code(g)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c11335209.count_unique_code(g)
	local check={}
	local count=0
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				count=count+1
			end
		end
		tc=g:GetNext()
	end
	return count
end
