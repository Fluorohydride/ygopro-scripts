--メタルフォーゼ・カーディナル
function c54401832.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c54401832.fscon)
	e1:SetOperation(c54401832.fsop)
	c:RegisterEffect(e1)
end
function c54401832.filter1(c)
	return c:IsFusionSetCard(0xe1)
end
function c54401832.filter2(c)
	return c:IsAttackBelow(3000)
end
function c54401832.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c54401832.filter1
	local f2=c54401832.filter2
	local minc=2
	local chkf=bit.band(chkfnf,0xff)
	local tp=e:GetHandlerPlayer()
	local fg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,77693536)
	local fc=fg:GetFirst()
	while fc do
		g:Merge(fc:GetEquipGroup():Filter(Card.IsControler,nil,tp))
		fc=fg:GetNext()
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		if aux.FConditionFilterFFR(gc,f1,f2,mg,minc,chkf) then
			return true
		elseif f2(gc) then
			mg:RemoveCard(gc)
			if aux.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
			return mg:IsExists(aux.FConditionFilterFFR,1,nil,f1,f2,mg,minc-1,chkf)
		else return false end
	end
	return mg:IsExists(aux.FConditionFilterFFR,1,nil,f1,f2,mg,minc,chkf)
end
function c54401832.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c54401832.filter1
	local f2=c54401832.filter2
	local chkf=bit.band(chkfnf,0xff)
	local fg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,77693536)
	local fc=fg:GetFirst()
	while fc do
		eg:Merge(fc:GetEquipGroup():Filter(Card.IsControler,nil,tp))
		fc=fg:GetNext()
	end
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	local minct=2
	local maxct=2
	if gc then
		g:RemoveCard(gc)
		if aux.FConditionFilterFFR(gc,f1,f2,g,minct,chkf) then
			if aux.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
			local g1=Group.CreateGroup()
			if f2(gc) then
				local mg1=g:Filter(aux.FConditionFilterFFR,nil,f1,f2,g,minct-1,chkf)
				if mg1:GetCount()>0 then
					--if gc fits both, should allow an extra material that fits f1 but doesn't fit f2
					local mg2=g:Filter(f2,nil)
					mg1:Merge(mg2)
					if chkf~=PLAYER_NONE then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
						g1:Merge(sg)
						mg1:Sub(sg)
						minct=minct-1
						maxct=maxct-1
						if not f2(sg:GetFirst()) then
							if mg1:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
								if minct<=0 then minct=1 end
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
								local sg=mg1:FilterSelect(tp,f2,minct,maxct,nil)
								g1:Merge(sg)
							end
							Duel.SetFusionMaterial(g1)
							return
						end
					end
					if maxct>1 and (minct>1 or Duel.SelectYesNo(tp,93)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg1:FilterSelect(tp,f2,minct-1,maxct-1,nil)
						g1:Merge(sg)
						mg1:Sub(sg)
						local ct=sg:GetCount()
						minct=minct-ct
						maxct=maxct-ct
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=mg1:Select(tp,1,1,nil)
					g1:Merge(sg)
					mg1:Sub(sg)
					minct=minct-1
					maxct=maxct-1
					if mg1:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
						if minct<=0 then minct=1 end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg1:FilterSelect(tp,f2,minct,maxct,nil)
						g1:Merge(sg)
					end
					Duel.SetFusionMaterial(g1)
					return
				end
			end
			local mg=g:Filter(f2,nil)
			if chkf~=PLAYER_NONE then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
				g1:Merge(sg)
				mg:Sub(sg)
				minct=minct-1
				maxct=maxct-1
			end
			if mg:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
				if minct<=0 then minct=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:Select(tp,minct,maxct,nil)
				g1:Merge(sg)
			end
			Duel.SetFusionMaterial(g1)
			return
		else
			if aux.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
			minct=minct-1
			maxct=maxct-1
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=g:FilterSelect(tp,aux.FConditionFilterFFR,1,1,nil,f1,f2,g,minct,chkf)
	local mg=g:Filter(f2,g1:GetFirst())
	if chkf~=PLAYER_NONE and not aux.FConditionCheckF(g1:GetFirst(),chkf) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
		g1:Merge(sg)
		mg:Sub(sg)
		minct=minct-1
		maxct=maxct-1
	end
	if mg:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
		if minct<=0 then minct=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:Select(tp,minct,maxct,nil)
		g1:Merge(sg)
	end
	Duel.SetFusionMaterial(g1)
end
