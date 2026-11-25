--次元障壁
local s,id,o=GetID()
function c83326048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,83326048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c83326048.target)
	e1:SetOperation(c83326048.operation)
	c:RegisterEffect(e1)
end
function c83326048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local types={1057,1056,1063,1073,1074}
	local alist=Duel.GetFlagEffectLabel(tp,id)
	if not alist then
		Duel.SetTargetParam(types[Duel.SelectOption(tp,table.unpack(types))+1])
	else
		local options={}
		for i = 1, 5, 1 do
			if bit.extract(alist,i)==0 then
				table.insert(options,types[i])
			end
		end
		Duel.SetTargetParam(options[Duel.SelectOption(tp,table.unpack(options))+1])
	end
end
function c83326048.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct,p=0,0
	if opt==1057 then ct=TYPE_RITUAL   p=1 end
	if opt==1056 then ct=TYPE_FUSION   p=2 end
	if opt==1063 then ct=TYPE_SYNCHRO  p=3 end
	if opt==1073 then ct=TYPE_XYZ      p=4 end
	if opt==1074 then ct=TYPE_PENDULUM p=5 end
	local alist=Duel.GetFlagEffectLabel(tp,id)
	if not alist then
		alist=1<<p
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,alist)
	else
		alist=alist|(1<<p)
		Duel.SetFlagEffectLabel(tp,id,alist)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c83326048.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c83326048.distg)
	e2:SetLabel(ct)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c83326048.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&e:GetLabel()>0
end
function c83326048.distg(e,c)
	return c:IsType(e:GetLabel())
end
